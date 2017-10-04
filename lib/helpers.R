## helpers.R

##
## histogram as example
##
exampleHist <- function( n ){
  
  set.seed(123)
  x <- rnorm( n )
  hist( x )
  
}

##
## readData function
##
readData <- function(){
  
  list( gardens = as.data.table( read.csv( "../data/NYC_Greenthumb_Community_Gardens.csv" ) ),
        air     = as.data.table( read.csv( "../data/Air_Quality.csv" ) ) )
  
}

##
## community garden leaflet plot
##
gardenLeaflet <- function( gardens, treeIcons ){
  
  leaflet( data = gardens ) %>% 
    addTiles() %>% 
    addMarkers( ~Longitude, ~Latitude, popup = ~as.character(Garden.Name), icon = treeIcons,
                clusterOptions = markerClusterOptions() )
  
}


