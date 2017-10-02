## ui.R

library(shiny)
library(shinydashboard)
library(data.table)
library(ggmap)
library(leaflet)

dashboardPage(
  
  ## dashboard header
  dashboardHeader( title = "Air Pollution in NYC" ),
  
  ## dashboard sidebar
  dashboardSidebar(
    sidebarMenu(
      # create Introduction Tab
      menuItem("Introduction", tabName = "intro"),
      
      # create Statistics Tab
      menuItem("Statistics",  tabName = "stats"),
      
      # create Maps Tab with subitems
      menuItem("Map", tabName = "map",
               menuSubItem('Air Quality',
                           tabName = 'tAirMap' ),
               menuSubItem('Community Gardens',
                           tabName = 'tGardenMap' ) ),
      
      # create Data Tab with subitems
      menuItem("Data", tabName = "data",
               menuSubItem('Air Quality',
                           tabName = 'tAirData' ),
               menuSubItem('Community Gardens',
                           tabName = 'tGardenData' ) )
      
    )),
  
  ## dashboard body
  dashboardBody(

    tabItems(
      
      # Introduction tab content
      tabItem(tabName = "intro",
              
              h2("Introduction"),
              
              print( "write introduction here" )
              
      ),
      
      # Statistics tab content
      tabItem(tabName = "stats",
              fluidRow(
                box(
                  title = "Sample size",
                  sliderInput("n", "Number of observations:", 1, 100, 50)
                ), 
                
                box( plotOutput( "plot1" ) )
                
              )
      ),
      
      # Map tab content
      tabItem(tabName = "tGardenMap",
              
              leafletOutput("leafletPlot")
              
      ),
      
      ## air quality data tab content
      tabItem( tabName = "tAirData",
               
               fluidRow(
                 column(12,
                        dataTableOutput('tableAir')
                 )
               )
      ),
      
      ## community garden data tab content
      tabItem( tabName = "tGardenData",
               
               fluidRow(
                 column(12,
                        dataTableOutput('tableGarden')
                 )
               )
      )
      
    )
))