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
  # list( gardens = as.data.table( read.csv( "../data/NYC_Greenthumb_Community_Gardens.csv" ) ),
  #       air     = as.data.table( read.csv( "../data/Air_Quality_new.csv" ) ), #change name
  #       bike    = as.data.table( read.csv( "../data/citibikeStations-012017.csv") ) )
  
  list( gardens = as.data.table( read.csv( "../data/NYC_Greenthumb_Community_Gardens.csv" ) ),
        air     = as.data.table( read.csv( "../data/Air_Quality_new.csv" ) ), #change name
        bike    =  read.csv( "../data/citibikeStations-012017.csv")  )
  
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
   addCircleMarkers(pol$lon,pol$lat, radius = 6, 
                     color = pol$color, fillOpacity = .6,stroke = FALSE) 
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
        addCircleMarkers(pol$lon,pol$lat, radius = 6, 
                    color = pol$color, fillOpacity = .6, stroke = FALSE) 
}

##

pollutantText <- function( pollutant ){
  
  if( pollutant == "Nitrogen Dioxide (NO2)" ){
    "Nitrogen Dioxide is an immediately dangerous pollutant. The EPA 
    has tied chronic exposure to nitrogen dioxide as causing lung irritation and eye irritation.
    Often, exposure to nitrogen dioxide from an indoor source, like a stove, is enough to send people 
    to the emergency room!"
    
  }
  
  else if( pollutant == "Ozone (O3)"){
    
    "Ozone in the Earth`s stratosphere absorbs radiation from the sun, and keeps the heat from 
    reaching our lower atmosphere. But ozone at low altitudes acts as a greenhouse gas, working to 
    raise global temperature by absorbing heat in the lower atmosphere."
    
  } 
  
  else if( pollutant =="Nitric Oxide (NO)"){
    " Nitric oxide reacts with oxygen to contribute to the depletion of the ozone layer, 
      exacerbating the effects caused by the increase in greenhouse gasses. Nitric oxide reacts with
      the oxygen in the atmosphere to create nitric dioxide, stripping away oxygen from the atmosphere. "
    
  }
  else if( pollutant == "Elemental Carbon (EC)"){
    "The simple elemental carbon, as well as carbon monoxide 
    and carbon Dioxide are greenhouse gasses. They are created from the
    combustion of both fossil fuels and biofuels, and the growing 
    presence of carbon and carbon compounds spell disaster for our environment 
    and those who live in it. The most direct effect of these pollutants
    comes in the changing of the weather. The carbon absorbs extra heat in the
    atmosphere and alters weather patterns. So why do we care about some warmer weather?
    Well, for one, areas that previously were farmable become too hot to farm. And furthermore,
    the increase in temperature leads to more wildfires, storms, and droughts, radically changing the
    lives of populations affected. For example, in the California Central Valley region, rising temperatures
    have dramatically affected the yield of tomato crops, wheat, rice, maize, and sunflowers. "
  }
  
  else if (pollutant == "Fine Particulate Matter (PM2.5)"){
    "Fine particulate matter is composed of tiny aerosol particles that are 2.5 micrometers 
    or smaller in size. The particulates typically are created by power plants, factories, and in part
    from automobiles. This pollutant, rather than indirectly causing weather changes, poses an immediate 
     problem for human health. The EPA has linked exposure to FPM with increased chance for asthma, heart 
     attack, and difficulty breathing. Not to mention that this pollutant is responsible for the haze you 
    can see over the city on certain mornings. "
      
  }
  else{
    ""
  }
  
}
  

#####
#####
#####

#define a function to transform address to longtitude and latitude
geocodeAdddress <- function(address) {
  require(RJSONIO)
  url <- "http://maps.google.com/maps/api/geocode/json?address="
  url <- URLencode(paste(url, address, "&sensor=false", sep = ""))
  x <- fromJSON(url, simplify = FALSE)
  if (x$status == "OK") {
    out <- c(x$results[[1]]$geometry$location$lng,
             x$results[[1]]$geometry$location$lat)
  } else {
    out <- NA
  }
  Sys.sleep(0.2)  # API only allows 5 requests per second
  out
}

# Calculate distance in kilometers between two points
earth.dist <- function (long1, lat1, long2, lat2)
{
  rad <- pi/180
  a1 <- lat1 * rad
  a2 <- long1 * rad
  b1 <- lat2 * rad
  b2 <- long2 * rad
  dlon <- b2 - a2
  dlat <- b1 - a1
  a <- (sin(dlat/2))^2 + cos(a1) * cos(b1) * (sin(dlon/2))^2
  c <- 2 * atan2(sqrt(a), sqrt(1 - a))
  R <- 6378.145
  d <- R * c
  return(d)
}


#define function to select data frame within ? kilometers of the location
distance <- function(data,loc,km){
  within_km=function(line_data,loc,km){
    line_data <- as.numeric(line_data)
    if(earth.dist(line_data[5],line_data[4],loc[1],loc[2])<=km){
      return(TRUE)
    }
    else{return(FALSE)}
  }
  index=c()
  for(i in 1:dim(data)[1]){
    if(within_km(data[i,],loc,km)==TRUE){
      index=c(index,TRUE)
    }
    else{
      index=c(index,FALSE)
    }
  }
  if(sum(index)==0){
    return('no data')
  }
  data_sel <- data[index,]
  
  dis=c()
  for(i in 1:dim(data_sel)[1]){
    dis=c(dis,earth.dist(data_sel[i,5],data_sel[i,4],loc[1],loc[2]))
  }
  data_sel$dis=dis
  
  data_sel=data_sel[order(data_sel$dis),]
  return(data_sel)
}
