# SIRI Stop Monitoring Service Real Time Transit Data for an Operator 

#' Realtime Predictions for all Stops for an Operator 
#' 
#' @return Dataframe of all predictions for stops covered by a particular operator up to 1000 stops
#' @param operator_id Operator ID to filter by 
#' @examples
#' get_realtime_predictions_for_operator(operator_id='AC')
#' @export
get_realtime_predictions_for_operator <- function(operator_id) {
  stops <- get_stops(operator_id=operator_id)
  ids <- suppressWarnings(as.integer(stops$id))
  ids <- unique(ids[!is.na(ids)])[1:1000]
  stop_predictions <- list() 
  for (id in ids) {
    stop_predictions[[i]] <- get_realtime_predictions_for_stop(operator_id=operator_id, stop_id=id)
  }
  stops <- data.table::rbindlist(stop_predictions, fill=T)
  return (ids)
}