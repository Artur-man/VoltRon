% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/objects.R
\docType{methods}
\name{VoltRon-methods}
\alias{VoltRon-methods}
\alias{$.VoltRon}
\alias{$<-.VoltRon}
\alias{.DollarNames.VoltRon}
\alias{[[,VoltRon,character,missing-method}
\alias{[[,VoltRon-methods}
\alias{[[<-,VoltRon,character,missing-method}
\alias{[[<-,VoltRon-methods}
\alias{[[,VoltRon,character,character-method}
\alias{[[<-,VoltRon,character,character-method}
\title{Methods for VoltRon}
\usage{
\method{$}{VoltRon}(x, i, ...)

\method{$}{VoltRon}(x, i) <- value

\method{.DollarNames}{VoltRon}(x, pattern = "")

\S4method{[[}{VoltRon,character,missing}(x, i, j, ...)

\S4method{[[}{VoltRon,character,missing}(x, i, j, ...) <- value

\S4method{[[}{VoltRon,character,character}(x, i, j, ...)

\S4method{[[}{VoltRon,character,character}(x, i, j, ...) <- value
}
\arguments{
\item{x}{A VoltRon object}

\item{i, value}{Depends on the usage
\describe{
 \item{\code{$}, \code{$<-}}{Name (\code{i}) of a single metadata column from the main assay, see \link{vrMainAssay}}
 \item{\code{[[}, \code{[[<-}}{
   If only \code{i} is given, either a vrSample object or a vrAssay for \code{i} (and \code{value}) being name of the sample or assay.
   If both \code{i} and \code{j} are given, vrLayer with layer name \code{j} (and \code{value}) of vrSample with same name \code{i}.
 }
}}

\item{...}{Arguments passed to other methods}

\item{pattern}{ A regular expression.  Only matching names are
    returned.
  }

\item{j}{Depends on the usage, see \code{i}.}
}
\value{
\code{[[<-}: \code{x} with the metadata or associated objects added
as \code{i}; if \code{value} is \code{NULL}, removes metadata or associated
object \code{i} from object \code{x}

\code{[[<-}: \code{x} with the metadata or associated objects added
as \code{i}; if \code{value} is \code{NULL}, removes metadata or associated
object \code{i} from object \code{x}
}
\description{
Methods for \code{\link{VoltRon}} objects for generics defined in other
packages
}
\section{Functions}{
\itemize{
\item \code{$}: Metadata access for \code{VoltRon} objects

\item \code{`$`(VoltRon) <- value}: Metadata overwrite for \code{VoltRon} objects

\item \code{.DollarNames(VoltRon)}: Autocompletion for \code{$} access for \code{VoltRon} objects

\item \code{x[[i}: Accessing vrAssay or vrSample objects from \code{VoltRon} objects

\item \code{`[[`(x = VoltRon, i = character, j = missing) <- value}: Overwriting vrAssay or vrSample objects from \code{VoltRon} objects

\item \code{x[[i}: Accessing vrLayer objects from \code{VoltRon} objects

\item \code{`[[`(x = VoltRon, i = character, j = character) <- value}: Overwriting vrLayer objects from \code{VoltRon} objects

}}
\concept{voltron}
