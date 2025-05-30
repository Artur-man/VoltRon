% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/allgenerics.R, R/assay.R, R/objects.R
\name{updateAssay}
\alias{updateAssay}
\alias{updateAssay,vrAssay-method}
\alias{updateAssay,vrAssayV2-method}
\alias{updateAssay,VoltRon-method}
\title{Update Assay}
\usage{
updateAssay(object, ...)

\S4method{updateAssay}{vrAssay}(object)

\S4method{updateAssay}{vrAssayV2}(object)

\S4method{updateAssay}{VoltRon}(object, assay = NULL)
}
\arguments{
\item{object}{a vrAssayV2 object to be converted to vrAssayV2}

\item{...}{arguments passed to other methods.}

\item{assay}{assay name (exp: Assay1) or assay class (exp: Visium, Xenium), see \link{SampleMetadata}. 
if NULL, the default assay will be used, see \link{vrMainAssay}.}
}
\description{
update assays from vrAssay to vrAssayV2
}
