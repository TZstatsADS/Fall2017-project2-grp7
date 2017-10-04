## server.R

library(shiny)
library(shinydashboard)
library(data.table)
library(ggmap)

# source auxiliary functions
source( "./helpers.R" )

shinyServer(
  
  function(input, output) 
  {
    
    ################################################################
    ## Reading input data
    ################################################################
    
    ## read community gardens data
    gardens <- as.data.table( read.csv( "../data/NYC_Greenthumb_Community_Gardens.csv" ) )
    
    ## read air quality data
    air      <- as.data.table( read.csv( "../data/Air_Quality.csv" ) )
    air$name <- as.character( air$name )
    air      <- air[ Measure == "Average Concentration" & year_description == "Annual Average 2009-2010" ]
    
    
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
      
      exampleHist( input$n )
      
    })
    
    ################################################################
    ## Maps
    ################################################################
    
    ## render map - static map - not used - delete later
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

