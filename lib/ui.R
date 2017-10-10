## ui.R

library(shiny)
library(shinydashboard)
library(data.table)
library(ggmap)
library(leaflet)
library(plotly)

dashboardPage(
  
  ## dashboard header
  dashboardHeader( title = "Green Life in NYC" ),
  
  ## dashboard sidebar
  dashboardSidebar(
    sidebarMenu(
      
      ################################################################
      ## Introduction tab side
      ################################################################
      menuItem("Introduction", tabName = "intro"),
      

      
      ################################################################
      ## Maps tab side
      ################################################################
      # create Maps Tab with subitems
      menuItem("Map", tabName = "map",
               
               menuItem('Air Quality',
                            tabName = 'tAirMap'),   
               menuItem('Community Gardens',
                           tabName = 'tGardenMap' ),
               menuItem('Citibike Stations',
                        tabName = 'tCitibikeMap' ) ),
      
      
      
      ################################################################
      ## Statistics tab side
      ################################################################
      menuItem("Statistics",  tabName = "stats",
               menuSubItem('Air Quality',
                           tabName = 'stat_air' )),
      
      
      
      ################################################################
      ## Datasets tab side
      ################################################################
      # create Data Tab with subitems
      menuItem("Data", tabName = "data",
               menuSubItem('Air Quality',
                           tabName = 'tAirData' ),
               menuSubItem('Community Gardens',
                           tabName = 'tGardenData' ),
               menuSubItem('Citibike station',
                           tabName = 'tBikeData' )),
      
      
      ################################################################
      ## Contact tab side
      ################################################################
      # create Data Tab with subitems
      menuItem("Contact us", tabName = "contact")
      
      
    )),
  
  ## dashboard body
  dashboardBody(

    tabItems(
      
      ################################################################
      ## Introduction tab body
      ################################################################
      # Introduction tab content
      tabItem(tabName = "intro",
              
              h2("Introduction"),
              
              print( "It's a recommendation system for green life in New York. We consider three aspects here: Air quality, Community graden and citibike station....." )
              
      ),
      
     
      
      ################################################################
      ## Maps tab body
      ################################################################
      
      # Garden map tab content
      tabItem(tabName = "tGardenMap",
              
              h2("Community Gardens In New York City"),
              
              h4("You can click the locations you want to explore. The number of green gardens in that region will be shown on the map."),
              
              leafletOutput("leafletGardenPlot")
              
      ),
      
      # Air quality map tab content
      tabItem(tabName = "tAirMap",
              
              h2("  Quantile Map of Air Quality in New York City"),
              
              tabsetPanel(
                
                tabPanel("PM2.5", 
                         fluidRow(
                                  box(checkboxGroupInput("pollutant_level", "Select pollutant Level", c("Low (Green)" =1, "Below Medium (yellow)" =2, "Above Medium (orange)" = 3, "High (red)" = 4),
                                                         selected = c(1,2,3,4)),width = 4),
                                  #box(analysis, height = 160),
                                  column(width=10, box(width = NULL, solidHeader = TRUE, leafletOutput("mapAirPlot1", height = 500))
                                  ))), 
                tabPanel("NO2", 
                         fluidRow(
                                  box(checkboxGroupInput("pollutant_level", "Select pollutant Level", c("Low (Green)" =1, "Below Medium (yellow)" =2, "Above Medium (orange)" = 3, "High (red)" = 4),
                                                         selected = c(1,2,3,4)),width = 4),
                                  #box(analysis, height = 160),
                                  column(width=10, box(width = NULL, solidHeader = TRUE, leafletOutput("mapAirPlot2", height = 500))
                                  ))),
                tabPanel("EC", 
                         fluidRow(
                                  box(checkboxGroupInput("pollutant_level", "Select pollutant Level", c("Low (Green)" =1, "Below Medium (yellow)" =2, "Above Medium (orange)" = 3, "High (red)" = 4),
                                                         selected = c(1,2,3,4)),width = 4),
                                  #box(analysis, height = 160),
                                  column(width=10, box(width = NULL, solidHeader = TRUE, leafletOutput("mapAirPlot3", height = 500))
                                  ))), 
                tabPanel("NO", 
                         fluidRow(
                                  box(checkboxGroupInput("pollutant_level", "Select pollutant Level", c("Low (Green)" =1, "Below Medium (yellow)" =2, "Above Medium (orange)" = 3, "High (red)" = 4),
                                                         selected = c(1,2,3,4)),width = 4),
                                  #box(analysis, height = 160),
                                  column(width=10, box(width = NULL, solidHeader = TRUE, leafletOutput("mapAirPlot4", height = 500))
                                  ))), 
                tabPanel("O3", 
                         fluidRow(
                                  box(checkboxGroupInput("pollutant_level", "Select pollutant Level", c("Low (Green)" =1, "Below Medium (yellow)" =2, "Above Medium (orange)" = 3, "High (red)" = 4),
                                                         selected = c(1,2,3,4)),width = 4),
                                  #box(analysis, height = 160),
                                  column(width=10, box(width = NULL, solidHeader = TRUE, leafletOutput("mapAirPlot5", height = 500))
                                  )))
               
                )
       ),
      
      # Citibike Stations map tab content
      tabItem(tabName = "tCitibikeMap",
              
              h2("Citibike Stations In New York City"),
              
              h4("You can click the locations you want to explore. The number of citibike stations in that region will be shown on the map."),
              
              
              leafletOutput("bikeStationsLeaflet")
              
      ),
      
      
      
      ################################################################
      ## Statistics tab body
      ################################################################
      tabItem(tabName = "stat_air",
              
              h2("Statistical Analysis for 5 Pollutants Related to Air Quality"),
              
              
              uiOutput("uiEda1"),
              plotlyOutput("plot1EDA"),
              uiOutput("uiEda2"),
              tabsetPanel(
                tabPanel("Radar Plot", plotOutput("radarplot")), 
                tabPanel("Pie Plot", plotlyOutput("plot2EDA")))
        
              
      ),
      
      
      ################################################################
      ## Datasets tab body
      ################################################################
      
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
      ),
      
      ## community bike data tab content
      tabItem( tabName = "tBikeData",
               
               fluidRow(
                 column(12,
                        dataTableOutput('tableBike')
                 )
               )
      ),
      
      ################################################################
      ## Contact  tab body
      ################################################################
      # Introduction tab content
      tabItem(tabName = "contact",
              
              h2("Contact us"),
              
              h3( "We are Group 7!"),
              
              h5("Cavalheiro De Paoli Lyrio, Joaquim jc4637@columbia.edu"),
              h5("Gao, Xin xg2249@columbia.edu"),
              h5("Guo, Xinyao xg2257@columbia.edu"),
              h5("Ni, Jiayu jn2585@columbia.edu"),
              h5("Thompson, Wyatt wct2112@columbia.edu")
           
      )
      
    )
))