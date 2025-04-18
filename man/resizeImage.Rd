% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/allgenerics.R, R/image.R
\name{resizeImage}
\alias{resizeImage}
\alias{resizeImage,VoltRon-method}
\alias{resizeImage,vrAssay-method}
\alias{resizeImage,vrAssayV2-method}
\alias{resizeImage,vrImage-method}
\alias{resizeImage,vrSpatial-method}
\title{resizeImage}
\usage{
resizeImage(object, ...)

\S4method{resizeImage}{VoltRon}(object, assay = NULL, name = NULL, reg = FALSE, size = NULL)

\S4method{resizeImage}{vrAssay}(object, name = NULL, reg = FALSE, size = NULL)

\S4method{resizeImage}{vrAssayV2}(object, name = NULL, reg = FALSE, size = NULL)

\S4method{resizeImage}{vrImage}(object, size = NULL)

\S4method{resizeImage}{vrSpatial}(object, size = NULL)
}
\arguments{
\item{object}{a VoltRon, vrAssay or vrSpatial object.}

\item{...}{arguments passed to other methods.}

\item{assay}{assay name (exp: Assay1) or assay class (exp: Visium, Xenium), see \link{SampleMetadata}. 
if NULL, the default assay will be used, see \link{vrMainAssay}.}

\item{name}{the name of the image}

\item{reg}{TRUE if registered coordinates of the main image (\link{vrMainSpatial}) is requested}

\item{size}{the width of the resized image}
}
\description{
Resizing Magick images
}
