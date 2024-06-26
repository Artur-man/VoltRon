% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generics.R, R/objects.R, R/assay.R, R/image.R
\name{vrCoordinates}
\alias{vrCoordinates}
\alias{vrCoordinates.VoltRon}
\alias{vrCoordinates.vrAssay}
\alias{vrCoordinates.vrImage}
\alias{vrCoordinates.vrSpatial}
\alias{vrCoordinates<-.VoltRon}
\alias{vrCoordinates<-.vrAssay}
\alias{vrCoordinates<-.vrImage}
\alias{vrCoordinates<-.vrSpatial}
\title{vrCoordinates}
\usage{
vrCoordinates(
  object,
  assay = NULL,
  image_name = NULL,
  spatial_name = NULL,
  reg = FALSE
)

\method{vrCoordinates}{VoltRon}(
  object,
  assay = NULL,
  image_name = NULL,
  spatial_name = NULL,
  reg = FALSE
)

\method{vrCoordinates}{vrAssay}(object, image_name = NULL, spatial_name = NULL, reg = FALSE)

\method{vrCoordinates}{vrImage}(object)

\method{vrCoordinates}{vrSpatial}(object)

\method{vrCoordinates}{VoltRon}(object, image_name = NULL, spatial_name = NULL, reg = FALSE) <- value

\method{vrCoordinates}{vrAssay}(object, image_name = NULL, spatial_name = NULL, reg = FALSE) <- value

\method{vrCoordinates}{vrImage}(object) <- value

\method{vrCoordinates}{vrSpatial}(object) <- value
}
\arguments{
\item{object}{a VoltRon, vrAssay or vrImage object}

\item{assay}{assay name (exp: Assay1) or assay class (exp: Visium, Xenium), see \link{SampleMetadata}. 
if NULL, the default assay will be used, see \link{vrMainAssay}.}

\item{image_name}{(deprecated, use \code{spatial_name}) the name/key of the image associated with the coordinates}

\item{spatial_name}{the name/key of the spatial system associated with the coordinates}

\item{reg}{TRUE if registered coordinates of the main image (\link{vrMainImage}) is requested}

\item{value}{new coordinates of spatial points}
}
\description{
Given a VoltRon, vrAssay or vrImage object, get and set the coordinates of assays and coordinate systems
}
