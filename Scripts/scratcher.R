######## SETUP ########## 
library(devtools)
#devtools::install_github('bhaskarvk/leaflet.extras')
library(leaflet.extras)
library(googleway)
library(leaflet)
library(magrittr)
library(rgdal)
library(sp)
library(ggplot2)

initlat <- 47.871008
initlong <- -122.494435
initzoom <- 9

mymapkey <- 'AIzaSyC7j5DjXgxDz-vxP5P1RPTMsdCLlgNSZN8' #for TransitDB project tracking) 

setwd('c:/users/matt clark/desktop/NWWATransitDash')

####################


#rgdal::ogrListLayers(dsn = './Data/TransitDB Commutes.kml')

sb90 <- rgdal::readOGR(dsn= './Data/TransitDB-commutes', 'Seattle-to-Bellevue-via-I90')
sb520 <- rgdal::readOGR(dsn= './Data/TransitDB-commutes', 'Seattle-to-Bellevue-via-SR520')

sb90fort <- ggplot2::fortify(sb90)
sb520fort <- ggplot2::fortify(sb520)


m <- leaflet() %>% 
  setView(lat = initlat, lng = initlong, zoom = initzoom)  %>% 
  addProviderTiles('CartoDB.Positron') %>% 
  addPolylines(data = sb90fort, lat = ~lat, lng = ~long, color = 'red') %>% 
  addPolylines(data = sb520fort, lat = ~lat, lng = ~long, color = 'blue')

m
####################

waypts90e <- list(via = c(47.589543, -122.268773))
waypts520e <- list(via = c(47.640561, -122.257863))

sb90dir <- google_directions(origin = 'Everett, WA', #c(47.617323, -122.188684), 
                             destination = 'Seattle, WA', #c(47.613799, -122.330012), 
                             mode = 'driving',
                             key = mapkey) 

sb90line <- decode_pl(sb90dir$routes$overview_polyline$points)
head(sb90line)


m <- leaflet() %>% 
  setView(lat = initlat, lng = initlong, zoom = initzoom)  %>% 
  addProviderTiles('CartoDB.Positron') %>% 
  addPolylines(data = sb90line, lat = ~lat, lng = ~lon, color = 'red')

m

head(quakes)