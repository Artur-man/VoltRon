% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ondisk.R
\name{saveVoltRon}
\alias{saveVoltRon}
\title{saveVoltRon}
\usage{
saveVoltRon(
  object,
  assay = NULL,
  format = c("InMemoryVoltRon", "HDF5VoltRon", "ZarrVoltRon"),
  output = NULL,
  replace = FALSE,
  chunkdim = NULL,
  level = NULL,
  as.sparse = NA,
  verbose = TRUE
)
}
\arguments{
\item{object}{a VoltRon object}

\item{assay}{assay name (exp: Assay1) or assay class (exp: Visium, Xenium), see \link{SampleMetadata}.}

\item{format}{the format the object should be written: InMemoryVoltRon (rds only), HDF5VoltRon (h5), or ZarrVoltRon (zarr).}

\item{output}{When saving, the directory will be created if it doesn't already exist. If the directory already exists and no prefix is specified and replace is set to TRUE, then it's replaced with an empty directory.}

\item{replace}{When no prefix is specified, should a pre-existing directory be replaced with a new empty one? The content of the pre-existing directory will be lost!}

\item{chunkdim}{The dimensions of the chunks to use for writing the assay data to disk.}

\item{level}{The compression level to use for writing the assay data to disk.}

\item{as.sparse}{as.sparse}

\item{verbose}{verbose}
}
\description{
save VoltRon object in memory or on disk
}
