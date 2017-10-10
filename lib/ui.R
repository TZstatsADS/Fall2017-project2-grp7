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
              
              tags$h4(type="html", " We care about living a green life, and we have a 
                     hunch that we’re not the only ones. Global warming 
                      is real, and driving our cars creates more 
                      greenhouse gasses that are contributing to the 
                      problem. Crops are yielding less food, glaciers 
                      are melting causing the ocean levels to rise, and 
                      droughts are plaguing areas that once had plenty 
                      of water. But on an individual level, living a 
                      green life is important too."),
              tags$h4("The academic 
                      literature on the effect of air pollutants on our 
                      health has grown dramatically in the last decade, 
                      all pointing in the same direction. We now know 
                      that breathing pollutants shares a strong 
                      correlation with small health problems like 
                      allergies and asthma, and even deathly 
                      cardiovascular diseases. In fact, the Global 
                      Burden of Disease has ranked exposure to 
                      particulate aerosol as the seventh most important 
                      factor to global mortality. And the National 
                      Institute of Health has identified a strong 
                      correlation between those who develop lung cancer 
                      and those who are exposed to air pollution on a 
                      daily basis."),
              tags$h4("Furthermore, these pollutants are 
                      more present in dense urban areas, and if New York 
                      City is anything, it’s a dense urban area. This is 
                      why we’ve made this tool. We want to help you live 
                      a life in New York City and enjoy the benefits of 
                      an urban life while avoiding the problems 
                      associated with breathing bad air. Our tool will 
                      help you"),
              
              tags$h4("•	Explore the distribution of air pollution in New York to help 
                      you find a place to live with cleaner air \n"
              ),
              
              tags$h4(" •	Show you the location of bike-share programs so you can help 
                      fight the problem of air pollution by avoiding the harmful fossil-
                      fuel combustion of motor vehicles \n"),
              tags$h4("•	Identify community gardens to help find organic, safe produce 
                      to avoid having to choose between potentially dangerous 
                      genetically modified organisms (GMO’s) and expensive organic 
                      alternatives \n"),
              
              tags$h4("We believe that living green is important, and we want to empower 
                      you live green. Enjoy our tool and use it to learn how to live an 
                      environmentally friendly life. It’s more important now than ever 
                      to learn about our environmental problems, because as Albert 
                      Einstein once said, “Problems cannot be solved at the same level 
                      of awareness that created them.\" " ),
              HTML('<p><img src="image_nyc.jpg"/></p>')
              
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
              
              h2("Air Quality Heat Map of New York City"),
              
              uiOutput("uiPollMap"),
              leafletOutput("mapAirPlot")
               
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