# SIRI Stop Monitoring Service Real Time Transit Data 

#' Real Time Predictions at a Stop 
#' 
#' Get real time arrival prediction for a specific stop ID 
#' 
#' @return Single row DataFrame with prediction for the specific stop 
#' 
#' @param operator_id ID of transit agency 
#' @param stop_id StopCode referring to a stop 
#' @examples 
#' get_realtime_predictions_for_stop(operator_id='AC', stop_id=53326)
#' @export
get_realtime_predictions_for_stop <- function(operator_id, stop_id) {
  path <- 'transit/StopMonitoring'
  query_params <- list(
    api_key=Sys.getenv('511BayArea_KEY'), 
    format='json', 
    agency=operator_id, 
    stopCode=stop_id
  ) 
  query_params <- query_params[!is.na(query_params)]
  
  predictions <- httr::GET(url=transit_base, path=path, query=query_params)
  prediction <- suppressWarnings(httr::content(predictions))
  prediction <- data.frame(prediction[1]$ServiceDelivery, stringsAsFactors = F)
  
  # Make column names readable 
  columns <- rep('', length(colnames(prediction)))
  names <- strsplit(colnames(prediction), '\\.') 
  i = 1
  for (name in names) {
    x <- ''
    n <- length(name)
    if (n > 1) {
      x <- (paste(name[n-1], name[n], sep='.'))
    }
    else {
      x <- (name[n])
    }
    columns[i] <- x 
    i = i+1
  }
  colnames(prediction) <- columns
  # Return dataframe of 1 row with stop prediction
  return(prediction)
}

