# Functions for accessing Transit APIs 
transit_base <- 'http://api.511.org/' 

#' Operators
#' 
#' Operators provide public transport services. 
#' 
#' @return Dataframe of transit operators in the Bay Area 
#' @examples 
#' get_operators()
#' @export
get_operators <- function() {
  path <- 'transit/operators'
  query_params <- list(
    api_key=Sys.getenv('511BayArea_KEY'), 
    format='json'
  )
  operators <- httr::GET(url=transit_base, path=path, query=query_params)
  print(operators$status_code)
  
  operator <- suppressWarnings(httr::content(operators))
  
  operator_list <- list()
  for (i in 1:length(operator)) {
    operator_list[[i]] <- data.frame(unlist(operator[[i]]), stringsAsFactors = F)
  }
  
  t_operator_list <- purrr::map(operator_list, t) 
  t_operator_list <- purrr::map(t_operator_list, data.frame)
  operator_list <- data.table::rbindlist(t_operator_list, fill=T)
  
  return (operator_list)
}

#' Lines
#'
#' Lines are routes covered by transit operators.
#'
#' @param operator_id filter lines by operator ID 
#' @return Dataframe of transit lines 
#' @examples
#' get_lines(operator_id='AC')
#' @export
get_lines <- function(operator_id) {
  path <- 'transit/lines'
  
  query_params <-  list(
    api_key=Sys.getenv('511BayArea_KEY'),
    format='json',
    operator_id=operator_id 
  )
  
  lines <- httr::GET(url=transit_base, path=path, query=query_params)
  print(lines$status_code)
  lines <- suppressWarnings(httr::content(lines))
  
  lines_list <- list() 
  for (i in seq_along(lines)) {
    lines_list[[i]] <- data.frame(lines[[i]])
  }
  lines_data <- data.table::rbindlist(lines_list, fill=T)
  
  return (lines_data)
}

#' Stop 
#' 
#' Stop provides the locations of stops for transit lines. More details about the physical characteristics of 
#' of each stop can be found from StopPlace 
#' The stop API provides ScheduledStopPoint which describes individual stops 
#' as well as StopAreas which describes the parent heirarchy of stops. 
#'
#' @param operator_id ID of the transit operator to filter the stops 
#' @return Dataframe of ScheduledStopPlace
#' @examples 
#' get_stops(operator_id='SF')
#' get_stops(operator_id='AC')
#' @export
get_stops <- function(operator_id) {
  path <- 'transit/stops'
  query_params <-  list(
    api_key=Sys.getenv('511BayArea_KEY'), 
    format='json', 
    operator_id=operator_id
  )
  
  stops <- httr::GET(url=transit_base, path=path, query=query_params)
  print(stops$status_code)
  stops <- suppressWarnings(httr::content(stops))
  scheduled_stops <- stops$Contents$dataObjects$ScheduledStopPoint
  
  stop_list <- list() 
  for (i in seq_along(scheduled_stops)) {
    stop_list[[i]] <- data.frame(scheduled_stops[[i]], stringsAsFactors = F)
  }
  stops <- data.table::rbindlist(stop_list, fill=T)
  
  return (stops)
}


#' StopPlace 
#' 
#' Description of each stop, including accessibility, address, and parking features 
#' 
#' @param operator_id Operator ID is used to filter the request 
#' @param stop_id ID identifying the stop
#' @return Dataframe of stops, columns are characteristics of stops 
#' @examples 
#' get_stopPlaces(operator_id='AC')
#' get_stopPlaces(operator_id='AC', stop_id=58772)
#' @export
get_stopPlaces <- function(operator_id, stop_id=NA) {
  path <- 'transit/stopPlaces'
  query_params <-  list(
    api_key=Sys.getenv('511BayArea_KEY'), 
    format='json', 
    operator_id=operator_id, 
    stop_id=stop_id
  )
  query_params <- query_params[!is.na(query_params)]
  
  stopPlaces <- httr::GET(url=transit_base, path=path, query=query_params)
  print(stopPlaces$status_code)
  
  stopPlaces <- suppressWarnings(httr::content(stopPlaces)$Siri$ServiceDelivery$DataObjectDelivery$dataObjects$SiteFrame$stopPlaces$StopPlace)
  return (stopPlaces)
}


#' Transit Annoucements 
#' 
#' @param operator_id Filter by an Operator ID 
#' @param line_id Filter by a Line ID for a transit route 
#' @return Dataframe of current announcements 
#' @examples 
#' get_transit_announcements() 
#' get_transit_announcements(operator_id='AC')
#' @export
get_transit_announcements <- function(operator_id=NA, line_id=NA) {
  path <- 'transit/transitannouncements'
  query_params <- list(
    api_key=Sys.getenv('511BayArea_KEY'), 
    format='json', 
    operator_id=operator_id, 
    line_id=line_id   
  ) 
  query_params <- query_params[!is.na(query_params)]
  
  announcements <- httr::GET(url=transit_base, path=path, query=query_params)
  print(announcements$status_code)
  announcements <- suppressWarnings(httr::content(announcements))
  announcements <- data.frame(t(data.frame(unlist(announcements))))
  return(announcements)
}












