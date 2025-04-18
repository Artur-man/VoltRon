% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/allgenerics.R, R/image.R
\name{vrMainSpatial}
\alias{vrMainSpatial}
\alias{vrMainSpatial,VoltRon-method}
\alias{vrMainSpatial,vrAssay-method}
\alias{vrMainSpatial,vrAssayV2-method}
\alias{vrMainSpatial<-,VoltRon-method}
\alias{vrMainSpatial<-,vrAssay-method}
\alias{vrMainSpatial<-,vrAssayV2-method}
\alias{vrMainSpatial<-}
\title{vrMainSpatial}
\usage{
vrMainSpatial(object, ...)

\S4method{vrMainSpatial}{VoltRon}(object, assay = NULL)

\S4method{vrMainSpatial}{vrAssay}(object)

\S4method{vrMainSpatial}{vrAssayV2}(object)

\S4method{vrMainSpatial}{VoltRon}(object, assay = NULL) <- value

\S4method{vrMainSpatial}{vrAssay}(object, ignore = FALSE) <- value

\S4method{vrMainSpatial}{vrAssayV2}(object, ignore = FALSE) <- value

vrMainSpatial(object, ...) <- value
}
\arguments{
\item{object}{a VoltRon or vrAssay object.}

\item{...}{arguments passed to other methods.}

\item{assay}{assay name (exp: Assay1) or assay class (exp: Visium, Xenium), see \link{SampleMetadata}. 
if NULL, the default assay will be used, see \link{vrMainAssay}.}

\item{value}{the name of main spatial coordinate system}

\item{ignore}{if TRUE, the non-existing spatial coordinate system will be ignored.}
}
\description{
Get the main spatial system name

Set the main image
}
