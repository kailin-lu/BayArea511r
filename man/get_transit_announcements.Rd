% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transit.R
\name{get_transit_announcements}
\alias{get_transit_announcements}
\title{Transit Annoucements}
\usage{
get_transit_announcements(operator_id = NA, line_id = NA)
}
\arguments{
\item{operator_id}{Filter by an Operator ID}

\item{line_id}{Filter by a Line ID for a transit route}
}
\value{
Dataframe of current announcements
}
\description{
Transit Annoucements
}
\examples{
get_transit_announcements() 
get_transit_announcements(operator_id='AC')
}
