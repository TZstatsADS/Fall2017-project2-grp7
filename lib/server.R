## server.R

library(shiny)
library(shinydashboard)
library(data.table)
library(ggmap)
library(plotly)
library(fmsb)

# source auxiliary functions
source( "./helpers.R" )

shinyServer(
  
  function(input, output) 
  {
    
    ################################################################
    ## Reading input data
    ################################################################
    
    ## read all input data
    inputData <- readData()
    
    ## get community gardens data
    gardens <- inputData$gardens
    
    ## get air quality data
    air      <- inputData$air
    air$name <- as.character( air$name )
    air$data_valuemessage<-as.numeric(as.character(air$data_valuemessage))
    air$geo_entity_name<-as.character(air$geo_entity_name)
    air      <- air[air$Measure == "Average Concentration" & air$year_description == "Annual Average 2009-2010",]
    air$pollutant <- substr(air$name,42,nchar(air$name))
    
    ## new air quality data for radar plot
    newair<-data.frame(matrix(rep(1,240),48,5))
    newair[,1] <- as.numeric(as.character(air$data_valuemessage))[air$pollutant=="Elemental Carbon (EC)"]
    newair[,2] <- as.numeric(as.character(air$data_valuemessage))[air$pollutant=="Fine Particulate Matter (PM2.5)"]
    newair[,3] <- as.numeric(as.character(air$data_valuemessage))[air$pollutant=="Nitric Oxide (NO)"]
    newair[,4] <- as.numeric(as.character(air$data_valuemessage))[air$pollutant=="Nitrogen Dioxide (NO2)"]
    newair[,5] <- as.numeric(as.character(air$data_valuemessage))[air$pollutant=="Ozone (O3)"]
    colnames(newair) <- levels(as.factor(air$pollutant))
    rownames(newair) <- air$geo_entity_name[1:48]
    
    ## get citibike stations data - JUST A COMMENT
    bikeStations <- inputData$bike
    
    ## create icon to display in map
    treeIcons <- icons(
      iconUrl = "./www/tree1.png",
      iconWidth = 14, iconHeight = 35,
      iconAnchorX = 22, iconAnchorY = 94
    )
    
    bikeIcon <- icons(
      iconUrl = "./www/bike1.png",
      iconWidth = 25, iconHeight = 20,
      iconAnchorX = 22, iconAnchorY = 94
    )
    
    
    ################################################################
    ## UI rendered
    ################################################################
    
    output$uiPollMap <- renderUI({
      
      selectInput( 'mapPollut', 'Choose pollutant', 
                     choices = c("All", unique(air$pollutant)), selected = "ALL") 
      
    })
    
    output$uiEda1 <- renderUI({
      
      selectInput( 'eda1Pollut', 'Choose pollutant', 
                   choices = c("ALL", unique(air$pollutant)), selected = "ALL")
      
    })
    
    output$uiEda2 <- renderUI({
      
      selectInput( 'eda2Neighborhood', 'Choose Neighborhood', 
                   choices = c("ALL", unique(air$geo_entity_name)), selected = "Manhattan")
      
    })
    

    ################################################################
    ## Exploratory Data Analysis Plot
    ################################################################
   
    ## render EDA plots
    output$plot1EDA <- renderPlotly({
      
      hist_and_density( data = air, type = input$eda1Pollut )
      
    })
    
    output$plot2EDA <- renderPlotly({
      
      pie( data = air, neighborhood = input$eda2Neighborhood )
      
    })
    
    output$radarplot <- renderPlot({
      radar( data = newair, neighborhood = input$eda2Neighborhood )

    })
    
    ################################################################
    ## Maps
    ################################################################
    
    ## render map - static map - not used - delete later
    output$ggmapAir <- renderPlot({
      
      ggmap(myMap) +
        geom_point( data = gardens, aes(x = Longitude, y = Latitude),
                   alpha = .5, color="green" )

      
    })
    
    ## render garden leaflet map
    output$leafletGardenPlot <- renderLeaflet({
      
      gardenLeaflet( gardens, treeIcons )
        
    })
    
    ## render citibike stations leaflet map
    output$bikeStationsLeaflet <- renderLeaflet({
      
      bikeStationLeaflet( bikeStations, bikeIcon )
      
    })
    
    ## render air quality heatmap -  CHANGE
    output$mapAirPlot <- renderLeaflet({
      
      #airHeatmap( air, input$mapPollut )
  
      #gardenLeaflet( gardens, treeIcons )
    
    })
    
    
    ################################################################
    ## Datasets
    ################################################################
    
    ## render community gardens datatable
    output$tableGarden <- renderDataTable( gardens )
    
    ## render air quality datatable
    output$tableAir    <- renderDataTable( air)  
    
    ## render bike station datatable
    output$tableBike <- renderDataTable( bikeStations )
    
  }
  
)

