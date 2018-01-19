# BayArea511r

This is a R client for the [511.org Bay Area APIs](https://511.org/developers/list/apis/). 

## Authentication 

Create an account on 511.org to receive an API key in your email. Place 

## APIs

See [Vignettes]() for more details on each API 

#### Real Time Predictions

```r 
# Get RT prediction for stop ID 53326 for AC Transit 
get_realtime_predictions_for_stop(operator_id='AC', stop_id=53326)
```

#### Transit

Return information about Bay Area transit companies including: 

1. List of operators 

```r
get_operators()
```

2. List of lines by operators 

```r
# Lines for AC Transit 
get_lines(operator_id='AC')
```

3. List of stops by operator or by operator 

```r
get_stops(operator_id='AC')
```

4. Stop descriptions by operator ID and stop ID 

```r
get_stopPlaces(operator_id='AC', stop_id=58772)
```

5. Current transit system announcements 

```r
get_transit_announcements() 
```


#### Traffic Events

Get a list of current or past traffic incidences in the Bay Area 

```r
traffic_events()
``` 


## Helpful Links 

[Google Forum for Bay Area 511 Developers](https://groups.google.com/forum/#!forum/511sfbaydeveloperresources)