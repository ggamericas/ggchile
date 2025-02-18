% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom.R
\name{geom_sf_regionchile}
\alias{geom_sf_regionchile}
\title{Title}
\usage{
geom_sf_regionchile(
  mapping = NULL,
  data = NULL,
  position = "identity",
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  crs = "NAD27",
  ...
)
}
\arguments{
\item{...}{}
}
\description{
Title
}
\examples{
library(ggplot2)
chile_region_flat \%>\%
ggplot() +
aes(region_codigo = region_codigo) +
geom_sf_regionchile()
}
