library(ggmap)
library(readr)
x<-geocode("East Harlem")
df<-read_csv("data/Air_Quality.csv")

df$loc<-NA
address<- data.frame(unique(df$geo_entity_name))
address$lon<-NA
address$lat<-NA
i=1
for(locs in unique(df$geo_entity_name)){
  temp<-geocode(paste(locs, ", New York"))
  address$lon[address$unique.df.geo_entity_name.==locs]<-temp[1]
  address$lat[address$unique.df.geo_entity_name.==locs]<-temp[2]
}
colnames(address)[1]<-"locs"
length(unique(df$geo_entity_name))
df2<-merge(df,address, by.x="geo_entity_name", by.y="locs")
nyc<-c(lon=-73.8,
       lat=40.7)
nyc.map<-get_map(location=nyc,zoom=10)
ggmap(nyc.map,extent = "panel")+
  geom_density2d(data=df2[grepl("Air Toxics Concentrations- Average Benzene",df2$name),],aes(x=lon,
                             y=lat))+
  stat_density2d(data = df2, aes(x=lon, y=lat, fill = ..level.., alpha = ..level..),
                 size = 0.01, bins = 15, geom = 'polygon') +
  scale_fill_gradient(low = "green", high = "red")+ggtitle("Where do we have data?")+   scale_alpha(range = c(0.15, 0.35), guide = FALSE) +
  theme(legend.position = "none", text = element_text(size = 12))


# nyc<-leaflet() %>%
#   addTiles() %>% addProviderTiles(providers$OpenStreetMap) %>% 
#   addMarkers(lng=73.8,lat=40.7)
# nyc
