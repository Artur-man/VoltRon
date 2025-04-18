% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/allgenerics.R, R/objects.R, R/assay.R
\name{vrFeatureData}
\alias{vrFeatureData}
\alias{vrFeatureData,VoltRon-method}
\alias{vrFeatureData,vrAssay-method}
\alias{vrFeatureData,vrAssayV2-method}
\alias{vrFeatureData<-,VoltRon-method}
\alias{vrFeatureData<-,vrAssay-method}
\alias{vrFeatureData<-,vrAssayV2-method}
\alias{vrFeatureData<-}
\title{Feature Data}
\usage{
vrFeatureData(object, ...)

\S4method{vrFeatureData}{VoltRon}(object, assay = NULL, feat_type = NULL)

\S4method{vrFeatureData}{vrAssay}(object)

\S4method{vrFeatureData}{vrAssayV2}(object, feat_type = NULL)

\S4method{vrFeatureData}{VoltRon}(object, assay = NULL) <- value

\S4method{vrFeatureData}{vrAssay}(object) <- value

\S4method{vrFeatureData}{vrAssayV2}(object, feat_type = NULL) <- value

vrFeatureData(object, ...) <- value
}
\arguments{
\item{object}{a VoltRon or vrAssay object.}

\item{...}{arguments passed to other methods.}

\item{assay}{assay name (exp: Assay1) or assay class (exp: Visium, Xenium), see \link{SampleMetadata}. 
if NULL, the default assay will be used, see \link{vrMainAssay}.}

\item{feat_type}{the feature set type}

\item{value}{new feature metadata}
}
\description{
Get and set feature data from the main.assay
}
