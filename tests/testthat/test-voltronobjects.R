# Testing functions of manipulating assays ####
test_that("assay", {

  # get data
  data("visium_data")

  # get assay names
  expect_equal(vrAssayNames(visium_data), "Assay1")

  # get assay object
  print(visium_data[["Assay1"]])

  # subset on assay name
  visium_data_sub <- subset(visium_data, assays = "Assay1")

  # subset on assay type
  visium_data_sub <- subset(visium_data, assays = "Visium")

  expect_equal(1,1L)
})

# Testing functions of manipulating samples ####
test_that("sample", {

  # get data
  data("visium_data")

  # get sample metadata
  print(SampleMetadata(visium_data))

  # change sample name
  visium_data$Sample <- "Test_Sample_Name"

  # check metadata
  expect_equal(unique(visium_data$Sample), "Test_Sample_Name")

  # check list name
  expect_equal(unique(names(visium_data@samples)), "Test_Sample_Name")

  # check metadata name
  sample.metadata <- SampleMetadata(visium_data)
  expect_equal(sample.metadata$Sample == "Test_Sample_Name", TRUE)

  expect_equal(1,1L)
})

# Testing functions of manipulating spatialpoints ####
test_that("spatialpoints", {

  # get data
  data("visium_data")

  # get spatial points
  print(head(vrSpatialPoints(visium_data)))
  print(head(vrSpatialPoints(visium_data, assay = "Assay1")))

  # subset on spatial points
  spatialpoints <- vrSpatialPoints(visium_data)
  visium_data_sub <- subset(visium_data, spatialpoints = spatialpoints[1:5])

  expect_equal(1,1L)
})

# Testing functions of manipulating coordinates ####
test_that("coordinates", {

  # get data
  data("visium_data")

  # coordinates
  coords <- vrCoordinates(visium_data)
  coords <- vrCoordinates(visium_data, image_name = "main")
  coords <- vrCoordinates(visium_data, spatial_name = "main")
  expect_warning(coords <- vrCoordinates(visium_data, reg = TRUE))
  expect_warning(coords <- vrCoordinates(visium_data, assay = "Assay1", reg = TRUE))

  # update coordinates
  vrCoordinates(visium_data) <- coords*2
  expect_error(vrCoordinates(visium_data, reg = TRUE) <- coords*3)

  # flip coordinates
  visium_data <- flipCoordinates(visium_data)

  # segments
  segments <- vrSegments(visium_data)
  expect_warning(segments <- vrSegments(visium_data, reg = TRUE))
  expect_warning(segments <- vrSegments(visium_data, assay = "Assay1", reg = TRUE))

  expect_equal(1,1L)
})

# Testing functions of manipulating images ####
test_that("image", {

  # get data
  data("visium_data")

  # get image
  images <- vrImages(visium_data)
  images <- vrImages(visium_data, name = "main")
  expect_error(images <- vrImages(visium_data, name = "main2"))
  images <- vrImages(visium_data, name = "main", channel = "H&E")
  expect_warning(images <- vrImages(visium_data, name = "main", channel = "H&E2"))

  # manipulate image
  visium_data_resize <- resizeImage(visium_data, size = 400)
  visium_data_modulate <- modulateImage(visium_data, brightness = 400)

  # add new image
  visium_data[["Assay1"]]@image[["new_image"]] <- vrImages(visium_data_resize)

  # get image names
  expect_equal(vrImageNames(visium_data), c("main", "new_image"))

  # get main image
  expect_equal(vrMainImage(visium_data[["Assay1"]]), "main")
  expect_equal(vrMainSpatial(visium_data[["Assay1"]]), "main")
  
  # change main image
  vrMainImage(visium_data[["Assay1"]]) <- "new_image"
  vrMainSpatial(visium_data[["Assay1"]]) <- "new_image"
  expect_equal(vrMainImage(visium_data[["Assay1"]]), "new_image")
  expect_equal(vrMainSpatial(visium_data[["Assay1"]]), "new_image")

  # return
  expect_equal(1,1L)
})

# Testing functions of manipulating embeddings ####
test_that("embeddings", {

  # get data
  data("visium_data")

  # write embedding
  vrEmbeddings(visium_data, type = "pca") <- vrCoordinates(visium_data)

  # check overwrite embeddings
  expect_error(vrEmbeddings(visium_data, type = "pca") <- vrCoordinates(visium_data))
  vrEmbeddings(visium_data, type = "pca", overwrite = TRUE) <- vrCoordinates(visium_data)

  # return
  expect_equal(1,1L)
})

# Testing functions of image datasets ####
test_that("importimagedata", {

  # import image data
  img <- system.file(package = "VoltRon", "extdata/DAPI.tif")
  vrimgdata <- importImageData(img, tile.size = 10, stack.id = 1)
  vrimgdata <- importImageData(img, tile.size = 10, stack.id = 2)

  # import image data when image is a stack
  img_magick <- magick::image_read(img)
  img_stack <- c(img_magick, img_magick)
  vrimgdata <- importImageData(img_stack, tile.size = 10, stack.id = 1)
  vrimgdata <- importImageData(img_stack, tile.size = 10, stack.id = 2)
  expect_error(vrimgdata <- importImageData(img_stack, tile.size = 10, stack.id = 3))

  # return
  expect_equal(1,1L)
})

# Testing functions of plots ####
test_that("plots", {

  # get data
  data("visium_data")
  data("xenium_data")

  # get custom colors
  colors <- scales::hue_pal()(length(unique(xenium_data$clusters)))
  names(colors) <- unique(xenium_data$clusters)

  # embedding plot
  vrEmbeddingPlot(xenium_data, group.by = "clusters", embedding = "umap", label = T)
  vrEmbeddingPlot(xenium_data, group.by = "clusters", embedding = "umap", group.ids = c(1,3,4), label = T)
  vrEmbeddingPlot(xenium_data, group.by = "clusters", embedding = "umap", colors = colors, label = T)
  vrEmbeddingPlot(xenium_data, group.by = "clusters", embedding = "umap", group.ids = c(1,3,4), colors = colors[c(1,3,4)], label = T)
  vrEmbeddingPlot(xenium_data, group.by = "clusters", ncol = 3, split.by = "clusters")
  vrEmbeddingPlot(xenium_data, group.by = "clusters", ncol = 3, split.by = "Sample")
  expect_error(vrEmbeddingPlot(xenium_data, group.by = "clusters", ncol = 3, split.by = "art"))

  # spatial plot
  vrSpatialPlot(xenium_data, group.by = "clusters", plot.segments = TRUE)
  vrSpatialPlot(xenium_data, group.by = "clusters", group.ids = c(1,3,4), plot.segments = TRUE)
  vrSpatialPlot(xenium_data, group.by = "clusters", colors = colors, plot.segments = TRUE)
  vrSpatialPlot(xenium_data, group.by = "clusters", group.ids = c(1,3,4), colors = colors[c(1,3,4)], plot.segments = TRUE)
  vrSpatialPlot(xenium_data, group.by = "clusters", background = "black")
  vrSpatialPlot(xenium_data, group.by = "clusters", background = "white")
  vrSpatialPlot(xenium_data, group.by = "clusters", background = "main")
  expect_warning(vrSpatialPlot(xenium_data, group.by = "clusters", background = c("main", "DAPI2")))
  
  # spatial plot without segmentation
  vrSpatialPlot(xenium_data, group.by = "clusters", plot.segments = FALSE)

  # spatial plot of visium
  vrSpatialPlot(visium_data)

  # spatial plot of melc data
  vrSpatialPlot(melc_data, group.by = "Clusters")
  expect_error(vrSpatialPlot(melc_data, group.by = "Clusters_new"))

  # feature plots
  vrSpatialFeaturePlot(visium_data, features = "Count")
  vrSpatialFeaturePlot(visium_data, features = "Stat1", norm = TRUE, log = TRUE)
  expect_error(vrSpatialFeaturePlot(visium_data, features = "Count_new"))
  
  # return
  expect_equal(1,1L)
})

# Testing functions of subsetting ####
test_that("subset", {
  
  # get data
  data("visium_data")

  # subset based on assay
  subset(visium_data, assays = "Assay1")
  subset(visium_data, assays = "Visium")
  expect_error(subset(visium_data, assays = "Visium2"))
  
  # subset based on samples
  subset(visium_data, samples = "Anterior1")
  expect_error(subset(visium_data, samples = "Anterior2"))
  
  # subset based on assay
  subset(visium_data, spatialpoints = c("GTTATATTATCTCCCT-1_Assay1", "GTTTGGGTTTCGCCCG-1_Assay1"))
  expect_error(subset(visium_data, spatialpoints = c("point")))
  
  # subset based on features
  subset(visium_data, features = c("Map3k19", "Rab3gap1"))
  expect_error(subset(visium_data, features = c("feature")))
  
  # return
  expect_equal(1,1L)
})

