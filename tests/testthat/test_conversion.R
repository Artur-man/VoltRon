# library
skip_on_ci() # dont test on GitHub actions

# file
h5ad_file <- tempfile(fileext = ".h5ad")
zarr_file <- tempfile(fileext = ".zarr")

test_that("as.AnnData", {

  # get data
  data("visium_data")
  data("xenium_data")

  # xenium to anndata
  as.AnnData(xenium_data, file = h5ad_file)
  as.AnnData(xenium_data, file = h5ad_file, assay = "Assay1")
  as.AnnData(xenium_data, file = h5ad_file, flip_coordinates = TRUE)

  # visium to anndata
  as.AnnData(visium_data, file = h5ad_file)
  as.AnnData(visium_data, file = h5ad_file, assay = "Assay1")
  as.AnnData(visium_data, file = h5ad_file, flip_coordinates = TRUE)
  
  # xenium to anndata
  as.AnnData(xenium_data, file = zarr_file)
  as.AnnData(xenium_data, file = zarr_file, assay = "Assay1")
  as.AnnData(xenium_data, file = zarr_file, flip_coordinates = TRUE)

  # visium to anndata
  as.AnnData(visium_data, file = zarr_file)
  as.AnnData(visium_data, file = zarr_file, assay = "Assay1")
  as.AnnData(visium_data, file = zarr_file, flip_coordinates = TRUE)
  
  # clean file
  file.remove(h5ad_file)
  unlink(zarr_file, recursive = TRUE)
  expect_equal(1,1L)
})

test_that("as.AnnData, python path", {
  
  # get data
  data("visium_data")
  data("xenium_data")
  
  # python.path
  expect_error(as.AnnData(visium_data, file = h5ad_file, python.path = ""))
  
  # python.path
  python.path <- system("which python", intern = TRUE)
  expect_error(as.AnnData(visium_data, file = zarr_file, python.path = python.path))
  expect_error(as.AnnData(visium_data, file = zarr_file, python.path = ""))
  
  # options path
  options(voltron.python.path = python.path)
  expect_error(as.AnnData(visium_data, file = zarr_file))
  options(voltron.python.path = NULL)
  expect_true(as.AnnData(visium_data, file = zarr_file))
  
  # clean file
  expect_equal(1,1L)
})