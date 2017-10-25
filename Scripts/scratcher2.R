heatPlugin <- htmlDependency("Leaflet.heat", "99.99.99",
                             src = c(href = "http://leaflet.github.io/Leaflet.heat/dist/"),
                             script = "leaflet-heat.js"
)

registerPlugin <- function(map, plugin) {
  map$dependencies <- c(map$dependencies, list(plugin))
  map
}

leaflet() %>% addTiles() %>%
  fitBounds(min(quakes$long), min(quakes$lat), max(quakes$long), max(quakes$lat)) %>%
  registerPlugin(heatPlugin) %>%
  onRender("function(el, x, data) {
           data = HTMLWidgets.dataframeToD3(data);
           data = data.map(function(val) { return [val.lat, val.long, val.mag*100]; });
           L.heatLayer(data, {radius: 25}).addTo(this);
           }", data = quakes %>% select(lat, long, mag))




#########################



restest <- spldf.test@data

splist <- list(latlist = list(NULL),
               longlist = list(NULL),
               res = restest
)

for (l in 1:dim(restest)[1]) { 
  
  splist$latlist[[l]] <- fortlist[[restest$corrcode[l]]]$lat
  splist$longlist[[l]] <- fortlist[[restest$corrcode[l]]]$long
    
}


polylineoffset_Plugin <- htmlDependency("Leaflet.PolylineOffset", "1.0.1",
                                        src = normalizePath(path = 'C:/users/matt clark/documents/R/win-library/3.4/Leaflet Plugins/Leaflet.PolylineOffset-master'),
                                        script = "leaflet.polylineoffset.js"
)

registerPlugin <- function(map, plugin) {
  map$dependencies <- c(map$dependencies, list(plugin))
  map
}


#for (var i = 0; 3; i++) { 
  
  L.polyline([ data.latlist[i], data.longlist[i]], { 
    color: data.res.color[i], 
    weight: 5, 
    offset: weight*i, 
  }).addTo(this);
  
}


leaflet() %>% addTiles() %>% 
  setView(lat = initlat, lng = initlong, zoom = initzoom) %>%
  registerPlugin(polylineoffset_Plugin) %>% 
  # addPolylines(data = spldf.mor, fillOpacity =  1,
  #              color = c('red', 'blue', 'yellow')) %>% #linecolormaker(pmchoice = input$pmetric, timechoice = input$moreve)) %>%
  addLegend('bottomleft', colors = colordf$linecolor,
            labels = colordf$bounds,
            title = 'Title', #paste('Average daily peak-period ', as.character(input$pmetric), sep = ''),
            layerId = 'legend') %>% 
  htmlwidgets::onRender(jsCode  = "function(el, x, data) {
                          L.polyline([
                                      [47.61324, -122.3300], 
                                      [47.98185, -122.1864]
                                    ], { 
                                      color: 'green', 
                                      weight: 4, 
                                      offset: -4
                                    }).addTo(this);
                                  }", 
                        data = splist)
  
  