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
    
  # return list with 3 datatables
  list( gardens = as.data.table( read.csv( "../data/NYC_Greenthumb_Community_Gardens.csv" ) ),
        air     = as.data.table( read.csv( "../data/Air_Quality_new.csv" ) ), #change name
        bike    = as.data.table( read.csv( "../data/citibikeStations-012017.csv") ) )
  
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


##
## citibike stations leaflet plot
##
bikeStationLeaflet <- function( bike, bikeIcons ){
  
  leaflet( data = bike ) %>% 
    addTiles() %>% 
    addMarkers( ~long, ~lat, popup = ~as.character(Name), icon = bikeIcons,
                clusterOptions = markerClusterOptions() )
  
}


#########EDA--Histogram and Density Plots to visualize each pollutant:
hist_and_density<-function(data,type){
  if(type=="ALL"){
    x <- data$data_valuemessage
    fit <- density(x)
    
    #Histogram and Density plot of overall pollutants
    plt<-plot_ly(x = x) %>% 
      add_histogram(name="Histogram") %>% 
      add_lines(x = fit$x, y = fit$y, fill = "tozeroy", yaxis = "y2",name="Density") %>% 
      layout(title = 'Level of All Pollutants Histogram',yaxis2 = list(overlaying = "y", side = "right"))
  }
  else {
    x <- data[data$pollutant==type,]$data_valuemessage
    fit <- density(x)
    #Histogram and Density plot of each pollutant
    plt<-plot_ly(x = x) %>% 
      add_histogram(name="Histogram") %>% 
      add_lines(x = fit$x, y = fit$y, fill = "tozeroy", yaxis = "y2",name="Density") %>% 
      layout(title = paste("Level of", type, "Histogram",sep=" "),yaxis2 = list(overlaying = "y", side = "right"))
  }
  return(plt)
}


#########EDA--Pie Chart to visualize different pollutants' proportion in each neighborhood:
pie<-function(data,neighborhood){
  if(neighborhood=="ALL"){
    p <- plot_ly(data,labels=~pollutant,values = ~data_valuemessage, type = 'pie') %>%
      layout(title = paste("Pollutant in NYC"),
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             showlegend = FALSE) 
  }
  else{
    p <- plot_ly(data[data$geo_entity_name==neighborhood,],labels=~pollutant,values = ~data_valuemessage, type = 'pie') %>%
      layout(title = paste("Pollutant in",neighborhood,sep=" "),
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             showlegend = FALSE) 
  }
  return(p)
}

#########EDA--Radar Plot to visualize different pollutants in each neighborhood:

radar<-function(data,neighborhood){
  if(neighborhood=="ALL"){
    p <- "Change the region for radar plots."
  }
  else{
    # name<-"New York City"
    newdata <- data[rownames(data)==neighborhood,]
    max<-apply(data,2,max)
    dt <- data.frame(rbind(max,rep(0,5),newdata))
    colnames(dt) <- c("EC","PM2.5","NO","NO2","03")
    p <- radarchart(dt,axistype = 2,
               pcol=rgb(0.2,0.5,0.5,0.9) , pfcol=rgb(0.2,0.5,0.5,0.5) , plwd=4 , 
               #custom the grid
               cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,100,20), cglwd=0.8,
               #custom labels
               vlcex=0.8) 
  }
  return(p)
}


#########EDA--Map Plot to visualize quantile levels of each pollutant in each neighborhood:

quan_map<-function(data,type,choice){
 # type="Nitrogen Dioxide (NO2)"
 # data=air
   air1 <- data[data$pollutant==type,]
   air1$level <- 1+rank(air1$data_valuemessage,ties.method="random")%/%(length(air1$data_valuemessage)/4)
   air1$color <- rep(1,48)
   for(i in 1:length(air1$level)){
      air1$color[i] <- ifelse(air1$level[i]==1,"green",ifelse(air1$level[i]==2,"yellow",ifelse(air1$level[i]==3,"orange","red")))
   } 
   pol <- air1[air1$level %in% as.numeric(choice),]
   p <- leaflet() %>% # popup
   addTiles() %>%
   setView(-73.96, 40.75, zoom = 9) %>%
    # add som markers:
   addCircleMarkers(pol$lon,pol$lat, radius = 5, 
                     color = pol$color, fillOpacity = 1, stroke = FALSE) 
   return(p)

}


quan_map0<-function(data,choice){
   air0<-data[data$pollutant=="Ozone (O3)",]
   air0$sum <- tapply(data$data_valuemessage,data$geo_entity_name,sum)
   air0$level <- 1+rank( air0$sum ,ties.method="random")%/%(length(air0$sum)/4)
   air0$color <- rep(1,48)
   for(i in 1:length(air0$level)){
        air0$color[i] <- ifelse(air0$level[i]==1,"green",ifelse(air0$level[i]==2,"yellow",ifelse(air0$level[i]==3,"orange","red")))
   } 
   pol <- air0[air0$level %in% as.numeric(choice),]
   p <- leaflet() %>% # popup
        addTiles() %>%
        setView(-73.96, 40.75, zoom = 9) %>%
  # add som markers:
        addCircleMarkers(pol$lon,pol$lat, radius = 5, 
                    color = pol$color, fillOpacity = 1, stroke = FALSE) 
}
