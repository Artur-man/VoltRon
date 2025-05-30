% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import.R
\name{importVisiumHD}
\alias{importVisiumHD}
\title{importVisiumHD}
\usage{
importVisiumHD(
  dir.path,
  bin.size = "8",
  selected_assay = "Gene Expression",
  assay_name = "VisiumHD",
  sample_name = NULL,
  image_name = "main",
  channel_name = "H&E",
  inTissue = TRUE,
  resolution_level = "lowres",
  ...
)
}
\arguments{
\item{dir.path}{path to Visium output folder}

\item{bin.size}{bin size of the VisiumHD output (Exp: "2", "8" and "16")}

\item{selected_assay}{selected assay from Visium}

\item{assay_name}{the assay name}

\item{sample_name}{the name of the sample}

\item{image_name}{the image name of the Visium assay, Default: main}

\item{channel_name}{the channel name of the image of the Visium assay, Default: H&E}

\item{inTissue}{if TRUE, only barcodes that are in the tissue will be kept (default: TRUE)}

\item{resolution_level}{the level of resolution of Visium image: "lowres" (default) or "hires"}

\item{...}{additional parameters passed to \link{formVoltRon}}
}
\description{
Importing VisiumHD data
}
