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
## community garden leaflet plot
##
gardenLeaflet <- function( gardens, treeIcons ){
  
  leaflet( data = gardens ) %>% 
    addTiles() %>% 
    addMarkers( ~Longitude, ~Latitude, popup = ~as.character(Garden.Name), icon = treeIcons,
                clusterOptions = markerClusterOptions() )
  
}
