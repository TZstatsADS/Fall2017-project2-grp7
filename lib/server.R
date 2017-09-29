## server.R

library(shiny)
library(shinydashboard)
library(data.table)
library(ggmap)

shinyServer(
  
  function(input, output) 
  {
    
    ## define map location and fetch it from Google's database
    myLocation <- "New York City"
    myMap      <- get_map(location = myLocation, source="google", maptype = "roadmap", crop=FALSE)
    
    ## read community gardens data
    gardens    <- as.data.table( read.csv( "../data/NYC_Greenthumb_Community_Gardens.csv" ) )
    
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
    
    ## render map
    output$plotMap <- renderPlot({
      
      ggmap(myMap) +
        geom_point( data = gardens, aes(x = Longitude, y = Latitude),
                   alpha = .5, color="green" )
      
    })
    
    ## render community gardens datatable
    output$table <- renderDataTable( gardens )
    
    
  }
  
)

