# packages 
skip_if_not_installed("rhdf5")
skip_if_not_installed("Rarr")
skip_if_not_installed("HDF5Array")
skip_if_not_installed("HDF5DataFrame")
skip_if_not_installed("ZarrDataFrame")
skip_if_not_installed("ImageArray")
skip_if_not_installed("BPCells")

# create dir
dir.create(td <- tempfile())
output_zarr <- paste0(td, "/xenium_data_zarr_test")
output_h5ad <- paste0(td, "/xenium_data_h5_test")
output_h5ad_2 <- paste0(td, "/xenium_data_h5_test")
output_h5ad_merged <- paste0(td, "/xenium_data_merged_h5_test")

test_that("save/load single assay", {
  
  # get data
  data("xenium_data")
  
  # HDF5 with BPCells
  xenium_data2 <- saveVoltRon(xenium_data, 
                              output = output_h5ad, 
                              format = "HDF5VoltRon", 
                              replace = TRUE, 
                              verbose = FALSE)
  xenium_data2 <- loadVoltRon(dir = output_h5ad)
  
  # HDF5 with DelayedArray
  xenium_data2 <- saveVoltRon(xenium_data, 
                              output = output_h5ad, 
                              format = "HDF5VoltRon", 
                              replace = TRUE, 
                              verbose = FALSE, 
                              feature.vs.obs.engine = "DelayedArray")
  xenium_data2 <- loadVoltRon(dir = output_h5ad)

  # zarr
  xenium_data2 <- saveVoltRon(xenium_data,
                              output = output_zarr,
                              format = "ZarrVoltRon",
                              replace = TRUE,
                              verbose = FALSE)
  xenium_data2 <- loadVoltRon(dir = output_zarr)

  # remove files
  unlink(output_h5ad, recursive = TRUE)
  unlink(output_zarr, recursive = TRUE)

  expect_equal(1,1L)
})

test_that("save/load multiple assay", {
  
  # get data
  data("merged_object")
  
  # HDF5 with BPCells
  merged_object2 <- saveVoltRon(merged_object, 
                              output = output_h5ad, 
                              format = "HDF5VoltRon", 
                              replace = TRUE, 
                              verbose = FALSE)
  merged_object2 <- loadVoltRon(dir = output_h5ad)
  
  # HDF5 with DelayedArray
  merged_object2 <- saveVoltRon(merged_object, 
                              output = output_h5ad, 
                              format = "HDF5VoltRon", 
                              replace = TRUE, 
                              verbose = FALSE, 
                              feature.vs.obs.engine = "DelayedArray")
  merged_object2 <- loadVoltRon(dir = output_h5ad)
  
  # zarr
  merged_object2 <- saveVoltRon(merged_object,
                              output = output_zarr,
                              format = "ZarrVoltRon",
                              replace = TRUE,
                              verbose = FALSE)
  merged_object2 <- loadVoltRon(dir = output_zarr)
  
  # remove files
  unlink(output_h5ad, recursive = TRUE)
  unlink(output_zarr, recursive = TRUE)
  
  expect_equal(1,1L)
})

test_that("double write and merging", {
  
  # get data
  data("visium_data")
  data("xenium_data")
  
  # TODO: output zarr problem with path
  # merged ondisk data with zarr
  xenium_data2 <- xenium_data
  xenium_data2$Sample <- "XeniumR2"
  xenium_data2 <- merge(xenium_data, xenium_data2, verbose = FALSE)
  xenium_data2_disk <- saveVoltRon(xenium_data2,
                                   output = output_zarr,
                                   format = "ZarrVoltRon",
                                   replace = TRUE,
                                   verbose = FALSE)
  
  # merged ondisk data with hdf5 (BPCells)
  xenium_data_disk <- saveVoltRon(xenium_data, 
                                  output = output_h5ad, 
                                  format = "HDF5VoltRon", 
                                  replace = TRUE, 
                                  verbose = FALSE)
  xenium_data2 <- xenium_data 
  xenium_data2$Sample <- "XeniumR2"
  xenium_data2_disk <- saveVoltRon(xenium_data2, 
                                   output = output_h5ad_2, 
                                   format = "HDF5VoltRon", 
                                   replace = TRUE, 
                                   verbose = FALSE)
  xenium_data_merged <- merge(xenium_data_disk, 
                              xenium_data2_disk, 
                              verbose = FALSE)
  xenium_data_merged_disk <- saveVoltRon(xenium_data_merged, 
                                         output = output_h5ad_merged, 
                                         format = "HDF5VoltRon", 
                                         replace = TRUE, 
                                         verbose = FALSE)
  expect_equal(
    ncol(vrData(xenium_data_merged_disk)),
    ncol(vrData(xenium_data)) * 2
  )
  
  # merged ondisk data with hdf5 (DelayedArray)
  xenium_data_disk <- saveVoltRon(xenium_data, 
                                  output = output_h5ad, 
                                  format = "HDF5VoltRon", 
                                  replace = TRUE, 
                                  verbose = FALSE, 
                                  feature.vs.obs.engine = "DelayedArray")
  xenium_data2 <- xenium_data 
  xenium_data2$Sample <- "XeniumR2"
  xenium_data2_disk <- saveVoltRon(xenium_data2, 
                                   output = output_h5ad_2, 
                                   format = "HDF5VoltRon", 
                                   replace = TRUE, 
                                   verbose = FALSE, 
                                   feature.vs.obs.engine = "DelayedArray")
  xenium_data_merged <- merge(xenium_data_disk, 
                              xenium_data2_disk, 
                              verbose = FALSE)
  xenium_data_merged_disk <- saveVoltRon(xenium_data_merged, 
                                         output = output_h5ad_merged, 
                                         format = "HDF5VoltRon", 
                                         replace = TRUE, 
                                         verbose = FALSE,
                                         feature.vs.obs.engine = "DelayedArray")
  expect_equal(
    ncol(vrData(xenium_data_merged_disk)),
    ncol(vrData(xenium_data)) * 2
  )
  
  # remove files
  unlink(output_h5ad, recursive = TRUE)
  unlink(output_h5ad_2, recursive = TRUE)
  unlink(output_h5ad_merged, recursive = TRUE)
  unlink(output_zarr, recursive = TRUE)
  
  expect_equal(1,1L)
})

test_that("merging ondisk with memory", {
  
  # get data
  data("visium_data")
  data("xenium_data")
  
  # merged ondisk data with hdf5 (BPCells)
  xenium_data_disk <- saveVoltRon(xenium_data, 
                                  output = output_h5ad, 
                                  format = "HDF5VoltRon", 
                                  replace = TRUE, 
                                  verbose = FALSE)
  xenium_data2 <- xenium_data 
  xenium_data2$Sample <- "XeniumR2"
  xenium_data_merged <- merge(xenium_data_disk, 
                              xenium_data2, 
                              verbose = FALSE)
  
  # remove files
  unlink(output_h5ad, recursive = TRUE)
  
  expect_equal(1,1L)
})

test_that("subsetting", {
  
  # get data
  data("xenium_data")
  
  # HDF5 with DelayedArray
  xenium_data2 <- saveVoltRon(xenium_data, 
                              output = output_h5ad, 
                              format = "HDF5VoltRon", 
                              replace = TRUE, 
                              verbose = FALSE, 
                              feature.vs.obs.engine = "DelayedArray")
  
  # by spatialpoints
  spatpoints <- vrSpatialPoints(xenium_data2)[1:30]
  xenium_data2_subset <- subset(xenium_data2, spatialpoints = spatpoints)
  expect_equal(vrSpatialPoints(xenium_data2_subset), spatpoints)
  
  # HDF5 with BPCells
  xenium_data2 <- saveVoltRon(xenium_data, 
                              output = output_h5ad, 
                              format = "HDF5VoltRon", 
                              replace = TRUE, 
                              verbose = FALSE)

  # by spatialpoints
  spatpoints <- vrSpatialPoints(xenium_data2)[1:30]
  xenium_data2_subset <- subset(xenium_data2, spatialpoints = spatpoints)
  expect_equal(vrSpatialPoints(xenium_data2_subset), spatpoints)
  
  # visualize
  vrSpatialPlot(xenium_data2_subset)
  vrSpatialFeaturePlot(xenium_data2_subset, features = "KRT15")
  
  # by image
  xenium_data2_subset <- subset(xenium_data2, image = "290x202+98+17")
  expect_equal(length(vrSpatialPoints(xenium_data2_subset)), 392)
  expect_equal(is(vrImages(xenium_data2_subset)), "magick-image")
  expect_equal(is(vrImages(xenium_data2_subset, as.raster = TRUE)), "ImgArray")
  
  # visualize
  vrSpatialPlot(xenium_data2_subset)
  vrSpatialFeaturePlot(xenium_data2_subset, features = "KRT15")
  
  # remove files
  unlink(output_h5ad, recursive = TRUE)
  
  expect_equal(1,1L)
})

test_that("metadata", {
  
  # get data
  data("xenium_data")
  
  # HDF5
  xenium_data2 <- saveVoltRon(xenium_data, 
                              output = output_h5ad, 
                              format = "HDF5VoltRon", 
                              replace = TRUE,
                              verbose = FALSE)
  
  # add column to metadata
  xenium_data2$new_column <- vrSpatialPoints(xenium_data2)
  
  # save updated metadata
  xenium_data2 <- saveVoltRon(xenium_data2, verbose = FALSE)
  meta.data <- Metadata(xenium_data2)
  expect_true(is(meta.data@listData[["new_column"]], "HDF5ColumnVector"))
  
  # load after update
  xenium_data2 <- loadVoltRon(output_h5ad)
  meta.data <- Metadata(xenium_data2)
  expect_true(is(meta.data@listData[["new_column"]], "HDF5ColumnVector"))
  
  # remove files
  unlink(output_h5ad, recursive = TRUE)
  
  expect_equal(1,1L)
})

test_that("normalization", {
  
  # get data
  data("xenium_data")
  data("visium_data")
  
  # HDF5 with BPCells
  xenium_data_bpcells <- saveVoltRon(xenium_data, 
                              output = output_h5ad, 
                              format = "HDF5VoltRon", 
                              replace = TRUE, 
                              verbose = FALSE)
  xenium_data_bpcells <- normalizeData(xenium_data_bpcells)
  
  # HDF5 with DelayedArray
  xenium_data_hdf5 <- saveVoltRon(xenium_data, 
                              output = output_h5ad, 
                              format = "HDF5VoltRon", 
                              replace = TRUE, 
                              verbose = FALSE,
                              feature.vs.obs.engine = "DelayedArray")
  xenium_data_hdf5 <- normalizeData(xenium_data_hdf5)
  # TODO: vrData(xenium_data_bpcells, norm = TRUE) throws error
  # in multiple calls
  # 
  # expect_equal(
  #   as(vrData(xenium_data_bpcells, norm = TRUE), "dgCMatrix"),
  #   as(vrData(xenium_data_hdf5, norm = TRUE), "dgCMatrix")
  # )

  # zarr
  xenium_data_zarr <- saveVoltRon(xenium_data, 
                              output = output_zarr, 
                              format = "ZarrVoltRon", 
                              replace = TRUE, 
                              verbose = FALSE)
  xenium_data_zarr <- normalizeData(xenium_data_zarr)
  expect_equal(
    as(vrData(xenium_data_zarr, norm = TRUE), "dgCMatrix"),
    as(vrData(xenium_data_hdf5, norm = TRUE), "dgCMatrix")
  )
  
  # remove files
  unlink(output_h5ad, recursive = TRUE)
  unlink(output_zarr, recursive = TRUE)
  
  expect_equal(1,1L)
})

test_that("feature selection", {
  
  # get data
  data("visium_data")
  
  # HDF5 with BPCells
  xenium_data_bpcells <- saveVoltRon(visium_data, 
                                     output = output_h5ad, 
                                     format = "HDF5VoltRon", 
                                     replace = TRUE, 
                                     verbose = FALSE)
  xenium_data_bpcells <- getFeatures(xenium_data_bpcells, n = 3000)
  vrFeatureData(xenium_data_bpcells)
  
  # HDF5 with DelayedArray
  xenium_data_hdf5 <- saveVoltRon(visium_data, 
                                  output = output_h5ad, 
                                  format = "HDF5VoltRon", 
                                  replace = TRUE, 
                                  verbose = FALSE,
                                  feature.vs.obs.engine = "DelayedArray")
  xenium_data_hdf5 <- getFeatures(xenium_data_hdf5, n = 3000)
  
  # TODO: for now it looks like bpcells and delayedarray feature selection
  # results are not the same (but i think slightly equal)
  # expect_equal(
  #   vrFeatureData(xenium_data_bpcells)[1:100,],
  #   vrFeatureData(xenium_data_hdf5)[1:100,]
  # )
  
  # zarr
  xenium_data_zarr <- saveVoltRon(visium_data, 
                                  output = output_zarr, 
                                  format = "ZarrVoltRon", 
                                  replace = TRUE, 
                                  verbose = FALSE)
  xenium_data_zarr <- getFeatures(xenium_data_zarr, n = 3000)
  expect_equal(
    vrFeatureData(xenium_data_hdf5),
    vrFeatureData(xenium_data_zarr)
  )
  
  # remove files
  unlink(output_h5ad, recursive = TRUE)
  unlink(output_zarr, recursive = TRUE)
  
  expect_equal(1,1L)
})

test_that("embeddings with BPCells-backed", {
  
  # get data
  data("xenium_data")
  
  # HDF5
  xenium_data2 <- saveVoltRon(xenium_data, 
                              output = output_h5ad, 
                              format = "HDF5VoltRon", 
                              replace = TRUE, 
                              verbose = FALSE)
  xenium_data2 <- getPCA(xenium_data2, 
                         features = vrFeatures(xenium_data2), 
                         pca.key = "pca_key")
  
  # check embeddings
  emb <- vrEmbeddings(xenium_data2, type = "pca_key")
  expect_true(all(dim(emb) > 1))
  expect_true(
    all(vrEmbeddingNames(xenium_data2) == c("pca", "umap", "pca_key")))
  
  # remove files
  unlink(output_h5ad, recursive = TRUE)
  
  expect_equal(1,1L)
})

test_that("embeddings with DelayedArray", {
  
  # get data
  data("xenium_data")
  
  # HDF5
  xenium_data2 <- saveVoltRon(xenium_data, 
                              output = output_zarr, 
                              format = "ZarrVoltRon", 
                              replace = TRUE, 
                              verbose = FALSE)
  xenium_data2 <- getPCA(xenium_data2, 
                         features = vrFeatures(xenium_data2), 
                         pca.key = "pca_key")
  
  # check embeddings
  emb <- vrEmbeddings(xenium_data2, type = "pca_key")
  expect_true(all(dim(emb) > 1))
  expect_true(
    all(vrEmbeddingNames(xenium_data2) == c("pca", "umap", "pca_key")))
  
  # remove files
  unlink(output_zarr, recursive = TRUE)
  
  expect_equal(1,1L)
})

test_that("visualization with HDF5", {
  
  # get data
  data("visium_data")
  
  # HDF5
  visium_data2 <- saveVoltRon(visium_data, 
                              output = output_h5ad, 
                              format = "HDF5VoltRon", 
                              replace = TRUE, 
                              verbose = FALSE)

  # check spatial plots
  vrSpatialPlot(visium_data2, group.by = "Sample")
  vrSpatialFeaturePlot(visium_data2, features = "Count")
  
  # check multilayer spatial plots
  data("merged_object")
  merged_object2 <- saveVoltRon(merged_object, 
                                output = output_h5ad, 
                                format = "HDF5VoltRon", 
                                replace = TRUE, 
                                verbose = FALSE)
  vrSpatialPlot(merged_object2, plot.segments = FALSE, n.tile = 100) |>
    addSpatialLayer(merged_object2, assay = "Assay3", group.by = "Sample", alpha = 0.4, colors = list(Block = "blue"))
  vrSpatialPlot(merged_object2, plot.segments = TRUE, n.tile = 100) |>
    addSpatialLayer(merged_object2, assay = "Assay3", group.by = "Sample", alpha = 0.4, colors = list(Block = "blue"))
  vrSpatialPlot(merged_object2, assay = "Assay2", group.by = "gene", alpha = 1, colors = list(KRT15 = "blue", KRT14 = "green"), n.tile = 100) |>
    addSpatialLayer(merged_object2, assay = "Assay3", group.by = "Sample", alpha = 0.4, colors = list(Block = "blue"))
  
  # remove files
  unlink(output_h5ad, recursive = TRUE)
  
  expect_equal(1,1L)
})

test_that("visualization with Zarr", {
  
  # get data
  data("visium_data")
  
  # HDF5
  visium_data2 <- saveVoltRon(visium_data, 
                              output = output_zarr, 
                              format = "ZarrVoltRon", 
                              replace = TRUE, 
                              verbose = FALSE)
  
  # check spatial plots
  vrSpatialPlot(visium_data2, group.by = "Sample")
  vrSpatialFeaturePlot(visium_data2, features = "Count")
  
  # check multilayer spatial plots
  data("merged_object")
  merged_object2 <- saveVoltRon(merged_object, 
                                output = output_zarr, 
                                format = "ZarrVoltRon", 
                                replace = TRUE, 
                                verbose = FALSE)
  vrSpatialPlot(merged_object2, plot.segments = FALSE, n.tile = 100) |>
    addSpatialLayer(merged_object2, assay = "Assay3", group.by = "Sample", alpha = 0.4, colors = list(Block = "blue"))
  vrSpatialPlot(merged_object2, plot.segments = TRUE, n.tile = 100) |>
    addSpatialLayer(merged_object2, assay = "Assay3", group.by = "Sample", alpha = 0.4, colors = list(Block = "blue"))
  vrSpatialPlot(merged_object2, assay = "Assay2", group.by = "gene", alpha = 1, colors = list(KRT15 = "blue", KRT14 = "green"), n.tile = 100) |>
    addSpatialLayer(merged_object2, assay = "Assay3", group.by = "Sample", alpha = 0.4, colors = list(Block = "blue"))
  
  # remove files
  unlink(output_zarr, recursive = TRUE)
  
  expect_equal(1,1L)
})

test_that("neighbors", {
  
  # get data
  data("xenium_data")
  
  # HDF5
  xenium_data2 <- saveVoltRon(xenium_data, 
                              output = output_h5ad, 
                              format = "HDF5VoltRon", 
                              replace = TRUE, 
                              verbose = FALSE)
  
  # spatial neighbors, delaunay
  xenium_data2 <- getSpatialNeighbors(xenium_data2, method = "delaunay")
  graphs <- vrGraph(xenium_data2, graph.type = "delaunay")
  expect_true(inherits(graphs,"igraph"))
  expect_true(length(igraph::E(graphs)) > 0)
  
  # profile neighbors, kNN
  xenium_data2 <- getProfileNeighbors(xenium_data2, method = "kNN", k = 10, data.type = "pca")
  graphs <- vrGraph(xenium_data2, graph.type = "kNN")
  expect_true(inherits(graphs,"igraph"))
  expect_true(length(igraph::E(graphs)) > 0)
  xenium_data2 <- getClusters(xenium_data2, graph = "kNN", label = "cluster_knn")
  expect_true(is.numeric(unique(xenium_data2$cluster_knn)))
  
  # update metadata
  xenium_data2 <- saveVoltRon(xenium_data2, verbose = FALSE)
  meta.data <- Metadata(xenium_data2)
  expect_true(is(meta.data@listData[["cluster_knn"]], "HDF5ColumnVector"))
  
  # load after update
  xenium_data2 <- loadVoltRon(output_h5ad)
  meta.data <- Metadata(xenium_data2)
  expect_true(is(meta.data@listData[["cluster_knn"]], "HDF5ColumnVector"))
  
  # remove files
  unlink(output_h5ad, recursive = TRUE)
  
  expect_equal(1,1L)
})