% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{air_temperature}
\alias{air_temperature}
\title{Air Temperature Trend Data}
\format{A tbl data frame:
\describe{
\item{Indicator}{The indicator name (chr)}
\item{Statistic}{The statistic with levels 'Mean', 'Minimum' or 'Maximum' (fctr)}
\item{Units}{The units (chr)}
\item{Period}{The period of the estimated change in years (int)}
\item{StartYear}{The first year (int)}
\item{EndYear}{The last year (int)}
\item{Ecoprovince}{The Ecoprovince (fctr)}
\item{Season}{The season with levels 'Annual', 'Spring', 'Summer', 'Fall' or 'Winter' (fctr)}
\item{Estimate}{The estimated trend (dbl)}
\item{Lower}{The estimated lower 95\% confidence interval in the trend (dbl)}
\item{Upper}{The estimated lower 95\% confidence interval in the trend (dbl)}
\item{Significant}{Whether the estimate is statistically significant at the 5\% level (lgl)}
}}
\usage{
air_temperature
}
\description{
Air temperature trend data imported and reformatted from
\url{https://catalogue.data.gov.bc.ca/dataset/long-term-change-in-air-temperature-and-precipitation-in-bc}.
}
\details{
Data licensed under the Open Data License-BC.
See metadata record in BC Data Catalogue for more details on the original data set.
}
\keyword{datasets}
