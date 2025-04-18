####
# Spatial Interactive Plot (VoltRon) ####
####

####
## Background Shiny App ####
####

#' vrSpatialPlotInteractive
#'
#' @inheritParams shiny::runApp
#' @param plot_g the ggplot plot
#' @param shiny.options a list of shiny options (launch.browser, host, port etc.) passed \code{options} arguement of \link{shinyApp}. For more information, see \link{runApp}
#'
#' @importFrom shinyjs useShinyjs
#' 
#' @noRd
vrSpatialPlotInteractive <- function(plot_g = NULL, 
                                     shiny.options = list()){
  
  # js for Shiny
  shinyjs::useShinyjs()

  # UI
  ui <- mod_app_ui("app")

  # Server
  server <- function(input, output, session) {
    mod_app_server("app", plot_g = plot_g)
    session$onSessionEnded(function() {
      stopApp()
    })
  }

  # get shiny options
  shiny.options = configure_shiny_options(shiny.options)
  
  # Start Shiny Application
  shiny::runApp(
    shiny::shinyApp(ui, server, options = list(host = shiny.options[["host"]], port = shiny.options[["port"]], launch.browser = shiny.options[["launch.browser"]]),
                    onStart = function() {
                      onStop(function() {
                      })
                    })
  )
}

#' App UI
#'
#' @param id id of the module
#'
#' @import shiny
#'
#' @noRd
mod_app_ui <- function(id) {
  ns <- NS(id)
  plotOutput(ns("image_plot"),
             height = "1000px",
             dblclick = ns("plot_dblclick"),
             brush = brushOpts(
               id = ns("plot_brush"), fill = "green",
               resetOnNew = TRUE
             ))
}

#' App Server
#'
#' @param id id of the module
#' @param plot_g the ggplot plot
#'
#' @import ggplot2
#'
#' @noRd
mod_app_server <- function(id, plot_g = NULL) {
  moduleServer(id, function(input, output, session) {

    ranges <- reactiveValues(x = plot_g$coordinates$limits$x, y = plot_g$coordinates$limits$y)
    observeEvent(input$plot_dblclick, {
      brush <- input$plot_brush
      if (!is.null(brush)) {
        ranges$x <- c(brush$xmin, brush$xmax)
        ranges$y <- c(brush$ymin, brush$ymax)
      } else {
        ranges$x <- plot_g$coordinates$limits$x
        ranges$y <- plot_g$coordinates$limits$y
      }
    })

    # image output
    output$image_plot <- renderPlot({
      plot_g +
        ggplot2::coord_equal(xlim = ranges$x, ylim = ranges$y, ratio = 1)
    })
  })
}

#' configure_shiny_options
#'
#' @param shiny.options a list of shiny options (launch.browser, host, port etc.) passed \code{options} arguement of \link{shinyApp}. For more information, see \link{runApp}
#'
#' @noRd
configure_shiny_options <- function(shiny.options){
  
  # check package
  if (!requireNamespace('rstudioapi'))
    stop("Please install rstudioapi package to use RStudio for interactive visualization")
  
  # launch.browser
  if("launch.browser" %in% names(shiny.options)){
    launch.browser <- shiny.options[["launch.browser"]]
  } else {
    launch.browser <- "RStudio"
  }
  if(!is.function(launch.browser)){
    if(launch.browser == "RStudio"){
      launch.browser <- rstudioapi::viewer
    } 
  }
  
  # host and port
  # if "port" is entered, parse "host" (or use default) but ignore "launch.browser"
  if("host" %in% names(shiny.options)){
    host <- shiny.options[["host"]]
  } else {
    host <- getOption("shiny.host", "0.0.0.0")
  }
  if("port" %in% names(shiny.options)){
    port <- shiny.options[["port"]]
    launch.browser <- TRUE
  } else {
    port <- getOption("shiny.port")
  }
  return(list(host = host, port = port, launch.browser = launch.browser))
}

####
# Spatial Interactive Plot (Vitessce) ####
####

#' vrSpatialPlotInteractive
#'
#' Interactive Plotting identification of spatially resolved cells, spots, and ROI on associated images from multiple assays in a VoltRon object.
#'
#' @param zarr.file The zarr file of a VoltRon object
#' @param group.by a grouping label for the spatial entities
#' @param reduction The name of the reduction to visualize an embedding alongside with the spatial plot.
#' @param shiny.options a list of shiny options (host, port etc.) passed \code{options} argument of \link{wc$widget}.
#' 
#' @noRd
vrSpatialPlotVitessce <- function(zarr.file, group.by = "Sample", reduction = NULL, shiny.options = NULL) {

  # check package
  if (!requireNamespace('vitessceR'))
    stop("Please install vitessceR package for using interactive visualization!: devtools::install_github('vitessce/vitessceR')")

  # check file
  if(!dir.exists(zarr.file))
    stop(zarr.file, " is not found at the specified location!")
  
  # get embedding
  if(is.null(reduction)){
    obs_embedding_paths <- c("obsm/spatial")
  } else {
    obs_embedding_paths <- c(paste0("obsm/", reduction), "obsm/spatial")
  }

  # initiate vitessceR
  vc <- vitessceR::VitessceConfig$new(schema_version = "1.0.15", name = "MBrain")
  dataset <- vc$add_dataset("My dataset")
  
  # add ome tiff if exists
  ometiff.file <- gsub("zarr[/]?$", "ome.tiff", zarr.file)
  if(file.exists(ometiff.file)){
    w_img <- vitessceR::MultiImageWrapper$new(
      image_wrappers = list(
        vitessceR::OmeTiffWrapper$new(name="Test1", img_path=ometiff.file)
      )
    )
    dataset <- dataset$add_object(w_img)
  } 
  
  # add anndata
  w_data <- vitessceR::AnnDataWrapper$new(
    adata_path=zarr.file,
    obs_set_paths = c(paste0("obs/", group.by)),
    obs_set_names = c(group.by),
    obs_locations_path = "obsm/spatial",
    obs_segmentations_path = "obsm/segmentation",
    obs_embedding_paths = obs_embedding_paths
  )
  dataset <- dataset$add_object(w_data)

  # set up vitessce pane  
  spatial <- vc$add_view(dataset, vitessceR::Component$SPATIAL)
  cell_sets <- vc$add_view(dataset, vitessceR::Component$OBS_SETS)
  spatial_segmentation_layer_value <- list(opacity = 1, radius = 0, visible = TRUE, stroked = FALSE)
  spatial_layers <- vc$add_view(dataset, vitessceR::Component$LAYER_CONTROLLER)

  if(is.null(reduction)){
    vc$layout(
      vitessceR::hconcat(spatial, 
                         vitessceR::hconcat(cell_sets, spatial_layers))
    )
  } else {
    umap <- vc$add_view(dataset, vitessceR::Component$SCATTERPLOT, mapping = reduction)
    vc$layout(
      vitessceR::hconcat(spatial, 
                         vitessceR::vconcat(umap, 
                                            vitessceR::hconcat(cell_sets, spatial_layers)))
    )
  }

  if(length(shiny.options) == 0){
    vc$widget(theme = "light")
  } else {
    if (!requireNamespace('rstudioapi'))
      stop("Please install rstudioapi package!: install.packages('rstudioapi')")
    message("Listening widget from ", shiny.options[["host"]], ":", shiny.options[["port"]])
    base = rstudioapi::translateLocalUrl(paste0(shiny.options[["host"]],":",shiny.options[["port"]]), absolute=TRUE)
    vc$widget(theme = "light", base_url=base, port=shiny.options[["port"]])
  }
}