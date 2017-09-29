## ui.R

library(shiny)
library(shinydashboard)
library(data.table)
library(ggmap)

dashboardPage(
  
  ## dashboard header
  dashboardHeader( title = "Air Pollution in NYC" ),
  
  ## dashboard sidebar
  dashboardSidebar(
    sidebarMenu(
      #menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Introduction", tabName = "intro"),
      menuItem("Statistics",  tabName = "stats"),
      menuItem("Map", tabName = "map"),
      menuItem("Data", tabName = "data")
    )),
  
  ## dashboard body
  dashboardBody(

    tabItems(
      # Introduction tab content - 
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
      tabItem(tabName = "map",
              
              plotOutput("plotMap")
              
      ),
      
      # Data tab content
      tabItem(tabName = "data",
              
              fluidRow(
                column(12,
                       dataTableOutput('table')
                )
              )
              
      )
      
    )
))