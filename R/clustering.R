#' @include allgenerics.R
#'
NULL

####
# Nearest Neighbor graphs ####
####

#' Get profile specific neighbors
#'
#' Get neighbors of spatial points
#'
#' @param object a VoltRon object
#' @param assay assay name (exp: Assay1) or assay class (exp: Visium, Xenium), see \link{SampleMetadata}. 
#' if NULL, the default assay will be used, see \link{vrMainAssay}.
#' @param method the method used for graph construction, SNN or kNN
#' @param k number of neighbors for kNN
#' @param data.type the type of embedding used for neighborhood calculation, e.g. raw counts (raw), normalized counts (norm), PCA embeddings (pca), UMAP embeddings (umap) etc.
#' @param dims the set of dimensions of the embedding data
#' @param graph.key the name of the graph
#'
#' @importFrom igraph add_edges simplify make_empty_graph vertices E<- E
#'
#' @export
getProfileNeighbors <- function(object, assay = NULL, method = "kNN", k = 10, data.type = "pca", dims = seq_len(30), graph.key = method){

  # get data
  if(data.type %in% c("raw", "norm")){
    nndata <- vrData(object, assay = assay, norm = (data.type == "norm"))
    nndata <- t(nndata)
  } else {
    embedding_names <- vrEmbeddingNames(object)
    if(data.type %in% vrEmbeddingNames(object)) {
      nndata <- vrEmbeddings(object, assay = assay, type = data.type, dims = dims)
    } else {
      stop("Please provide a data type from one of three choices: raw, norm and pca")
    }
  }

  # find profile neighbors
  nnedges <- knn_annoy(nndata, k = k + 1)
  names(nnedges) <- c("nn.index", "nn.dist")
  weights <- NULL
  nnedges <-
    switch(method,
           SNN = {
             g.out <- build_snn_number(nnedges$nn.index)
             nnedges <- g.out[[1]]
             weights <- g.out[[2]]
             weights <- weights/(2 * (k+2) - weights)
             nnedges
           },
           kNN = {
             nnedges <- nnedges$nn.index
             nnedges <- cbind(seq_len(nrow(nndata)), nnedges)
             nnedges <- apply(nnedges, 1, function(x){
               do.call(c,lapply(x[-1], function(y) return(c(x[1],y))))
             })
             nnedges
           })
  nnedges <- rownames(nndata)[nnedges]

  # make graph and add edges
  graph <- make_empty_graph(directed = FALSE) + vertices(rownames(nndata))
  graph <- add_edges(graph, edges = nnedges)
  if(!is.null(weights))
    igraph::E(graph)$weight <- weights
  graph <- simplify(graph, remove.multiple = TRUE, remove.loops = FALSE)
  vrGraph(object, graph.type = graph.key) <- graph

  # return
  return(object)
}

#' knn_annoy
#' 
#' knn engine employed by RcppAnnoy package, adapted from \code{BPCells} package.
#' 
#' @rdname knn
#' 
#' @details **knn_annoy**: Use RcppAnnoy as knn engine
#' 
#' @param data data
#' @param query query data (Default: data)
#' @param k number of neighbors for kNN
#' @param n_trees Number of trees during index build time. More trees gives higher accuracy
#' @param search_k Number of nodes to inspect during the query, or -1 for default value. Higher number gives higher accuracy
#' 
#' @importFrom RcppAnnoy AnnoyEuclidean
knn_annoy <- function(data, query = data, k = 10, n_trees = 50, search_k = -1) {
  annoy <- new(RcppAnnoy::AnnoyEuclidean, ncol(data))
  for (i in seq_len(nrow(data))) {
    annoy$addItem(i - 1, data[i, ])
  }
  annoy$build(n_trees)
  
  idx <- matrix(nrow = nrow(query), ncol = k)
  dist <- matrix(nrow = nrow(query), ncol = k)
  rownames(idx) <- rownames(query)
  rownames(dist) <- rownames(query)
  for (i in seq_len(nrow(query))) {
    res <- annoy$getNNsByVectorList(query[i, ], k, search_k, include_distances = TRUE)
    idx[i, ] <- res$item + 1
    dist[i, ] <- res$dist
  }
  list(idx = idx, dist = dist)
}

####
# Clustering ####
####

#' getClusters
#'
#' Get clustering of the VoltRon object
#'
#' @param object a VoltRon object.
#' @param assay assay name (exp: Assay1) or assay class (exp: Visium, Xenium), see \link{SampleMetadata}. 
#' if NULL, the default assay will be used, see \link{vrMainAssay}.
#' @param label the name for the newly created clustering column in the metadata.
#' @param method The method of clustering. Use :
#' (i) 'leiden' to perform graph clustering and 
#' (ii) 'kmeans' for K-means based clustering
#' (iii) 'hierarchical' for hierarchical clustering.
#' @param resolution the resolution parameter for leiden clustering.
#' @param graph the graph type to be used.
#' @param data.type the type of data used to cluster spatial points: 
#' "norm" (default), "raw" or an existing embeddings \link{vrEmbeddingNames}.
#' @param dims the number of dimensions extracted from the embedding if data.type is not NULL
#' @param nclus The number of cluster centers for K-means or hierarchical clustering.
#' @param distance_measure the distance measure used by hierarchical clustering. See \code{method} for a list of distance measures in \link{dist}.
#' @param abundance_limit the minimum number of points for a cluster, hence clusters with abundance lower than this limit will be appointed to other nearby clusters.
#' @param seed seed.
#'
#' @importFrom igraph cluster_leiden
#' @importFrom stats kmeans hclust cutree as.dist
#' 
#' @export
getClusters <- function(object, 
                        assay = NULL, 
                        label = "clusters", 
                        method = "leiden", 
                        resolution = 1, 
                        graph = "kNN", 
                        data.type = "norm",
                        dims = 1:30,
                        nclus = integer(0), 
                        distance_measure = "manhattan", 
                        abundance_limit = 2, 
                        seed = 1){

  # sample metadata
  sample.metadata <- SampleMetadata(object)

  # get assay names
  assay_names <- vrAssayNames(object, assay = assay)

  # get assays
  object_subset <- subsetVoltRon(object, assays = assay_names)

  # check clustering parameters
  .check_clustering_params(method, resolution, nclus, abundance_limit)
  
  # get data type if data_type is specified 
  embedding_names <- vrEmbeddingNames(object)
  if (data.type %in% embedding_names) {
    
    # get data
    vrdata <- vrEmbeddings(object,
                             assay = assay,
                             type  = data.type,
                             dims  = dims)
  } else if(!is.null(data.type)){
    vrdata <- t(vrData(object_subset, norm = data.type == "norm"))
  }

  # clustering
  set.seed(seed)
  if(method == "leiden"){
    object_graph <- vrGraph(object_subset, assay = assay, graph.type = graph)
    clusters <- igraph::cluster_leiden(object_graph, objective_function = "modularity", resolution = resolution) 
  } else if(method == "kmeans"){
    clusters <- stats::kmeans(vrdata, centers = nclus)
    clusters <- list(names = names(clusters$cluster), membership = clusters$cluster)
  } else if(method == "hierarchical"){
    # switch(distance_measure,
    #        {
    #          propor_dis <- dist(x = vrdata, method = distance_measure)
    #        }
    #        )
    propor_dis <- dist(x = vrdata, method = distance_measure)
    clusters <- stats::hclust(d = propor_dis, method = "ward.D2")
    clusters <- stats::cutree(clusters, k = nclus)
    clusters <- list(names = names(clusters), membership = clusters)
  } else {
    stop("Unrecognized clustering method! Use either 'leiden' for graph clustering or 'kmeans' for K-means clustering")
  }

  # correct clustering for low abundant clusters
  clusters <- .correct_low_abundant_clusters(object_graph, clusters, abundance_limit)
    
  # update metadata
  spatialpoints <- vrSpatialPoints(object, assay = assay)
  membership <- setNames(rep(NA,length(spatialpoints)), spatialpoints)
  membership[clusters$names] <- clusters$membership
  object <- addMetadata(object, assay = assay, value = membership, label = label)

  # return
  return(object)
}

#' @noRd
.correct_low_abundant_clusters <- function(object_graph, clusters, abundance_limit){

  # cluster abundances
  cluster_abundance <- table(clusters$membership)
  
  # check if some clusters are low in abundance
  ind <- cluster_abundance < abundance_limit
  if(any(ind)){
    low_abundant_clusters <- names(cluster_abundance)[ind]
    clusters$membership[clusters$membership %in% low_abundant_clusters] <- NA
  } 
  return(clusters)
}

#' @noRd
.check_clustering_params <- function(method, resolution, nclus, abundance_limit){
  
  # method related params
  if(method == "leiden"){
    msg <- "Resolution must be a single numeric and above 0"
    if(!is.numeric(resolution))
      stop(msg) 
    if(length(resolution) > 1)
      stop(msg) 
    if(resolution == 0 | resolution < 0)
      stop(msg)
  } else if(method == "kmeans"){
    msg <- "Number of cluster centres (nclus) must be a single integer and should be above 1"
    if(!is.numeric(nclus))
      stop(msg) 
    if(length(nclus) > 1)
      stop(msg) 
    if(nclus %% 1 != 0)
      stop(msg) 
    if(nclus == 0)
      stop(msg) 
  }
  
  # low abundant clusters
  msg <- "Low abundance limit must be a single integer and should be above 0"
  if(!is.numeric(abundance_limit))
    stop(msg) 
  if(length(abundance_limit) > 1)
    stop(msg) 
  if(abundance_limit %% 1 != 0)
    stop(msg) 
  if(abundance_limit == 0 || abundance_limit < 0)
    stop(msg) 
}

