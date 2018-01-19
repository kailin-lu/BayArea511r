library(httr)
library(dplyr)
library(tidyr)
library(purrr)
library(jsonlite)
library(data.table)

traffic_base <- 'http://api.511.org/'
path <- '/Traffic/Events' 

#' Retrieve a list of traffic events from today.
#' 
#' @param status Default 'ALL'. 
#' @param headline Summary of event. 
#' @param event_type Type of event such as CONSTRUCTION, SPECIAL_EVENT
#' @param severity level of severity of event. Note this is usually UNKNOWN
#' @param updated UTC timestamp of event updated on or after.
#' @param schedule UTC timestamp of times event is active 
#' @param limit Limiting number of events to return 
#' @return Dataframe of events filtered to parameters passed
#' @examples
#' traffic_events()
#' traffic_events(status='ACTIVE')
#' traffic_events(event_type='CONSTRUCTION')
#' @export
traffic_events <- function(status='ACTIVE', headline=NA, event_type=NA, severity=NA, 
                           updated=NA, schedule=NA, limit=10000) {
  
  # Error checking on parameters which have specific values 
  if (!is.na(status)) {
    if (!(status %in% c('ACTIVE', 'ARCHIVED', 'ALL'))) {
      return(paste('Status must be in: ACTIVE, ARCHIVE, ALL'))
    }
  } 
  
  if (!is.na(event_type)) {
    if (!(event_type %in% c('CONSTRUCTION', 'SPECIAL_EVENT', 'INCIDENT', 'WEATHER_CONDITION', 'ROAD_CONDITION'))) {
      return(paste('Event type must be in event type values list'))
    }
  }
  
  query_params <- list(
    api_key=Sys.getenv('511BayArea_KEY'), 
    format='json', 
    Status=status, 
    headline=headline, 
    event_type=event_type, 
    schedule=schedule, 
    updated>=updated, 
    limit=limit
  ) 
  query_params <- query_params[!is.na(query_params)]
  
  traffic <- httr::GET(url=traffic_base, 
                 path=path, 
                 query=query_params)
  print(traffic$status_code)  # Print response as a check
  
  events <- suppressWarnings(httr::content(traffic))$events
  event_list<- list()
  for (i in seq_along(events)) {
    events[[i]]$geography$coordinates <- paste(events[[i]]$geography$coordinates[[1]],
                                               events[[i]]$geography$coordinates[[2]], sep=",")
    events[[i]]$schedule$intervals <- paste(events[[i]]$schedule$intervals)
    event_list[[i]] <- data.frame(events[[i]], stringsAsFactors = F)
  }
  event_list <- data.table::rbindlist(event_list, fill=T)
  return (event_list)
}
