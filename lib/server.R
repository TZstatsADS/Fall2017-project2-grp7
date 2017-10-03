## server.R

library(shiny)
library(shinydashboard)
library(data.table)
library(ggmap)

shinyServer(
  
  function(input, output) 
  {
    
    ## read community gardens data
    gardens <- as.data.table( read.csv( "../data/NYC_Greenthumb_Community_Gardens.csv" ) )
    
    ## read air quality data
    air     <- as.data.table( read.csv( "../data/Air_Quality.csv" ) )
    
    ## create dummy air quality data table
    airQuality <- as.data.table( matrix( rnorm(120), nrow = 40, ncol = 3 ) )
    
    ## create icon to display in map
    treeIcons <- icons(
      iconUrl = "./www/tree1.png",
      iconWidth = 14, iconHeight = 35,
      iconAnchorX = 22, iconAnchorY = 94
    )
    
    ################################################################
    ## Exploratory Data Analysis Plot
    ################################################################
   
    ## render EDA plots
    output$plot1 <- renderPlot({
      
      ## filter
      set.seed(123)
      x <- rnorm( input$n )
      hist( x )
      
    })
    
    ## render map - static map - delete later
    output$plotMap <- renderPlot({
      
      ggmap(myMap) +
        geom_point( data = gardens, aes(x = Longitude, y = Latitude),
                   alpha = .5, color="green" )

      
    })
    
    ## render leaflet map
    output$leafletPlot <- renderLeaflet({
      
      leaflet( data = gardens ) %>% 
        addTiles() %>% 
        addMarkers( ~Longitude, ~Latitude, popup = ~as.character(Garden.Name), icon = treeIcons,
                    clusterOptions = markerClusterOptions() )
        
    })
    
    ## render community gardens datatable
    output$tableGarden <- renderDataTable( gardens )
    
    ## render air quality datatable
    output$tableAir    <- renderDataTable( air[ Measure == "Average Concentration" ] )  
    
  }
  
)

