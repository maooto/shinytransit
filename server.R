
### SHINY SERVER

shinyServer(function(input, output) { 
  
  ## INVOKE LEAFLET PLUGINS #############
  # polylineoffset_Plugin <- htmlDependency("Leaflet.PolylineOffset", "1.0.1",
  #                                         src = normalizePath(path = 'C:/users/matt clark/documents/R/win-library/3.4/Leaflet Plugins/Leaflet.PolylineOffset-master'),
  #                                         script = "leaflet.polylineoffset.js"
  # )
  # 
  # registerPlugin <- function(map, plugin) {
  #   map$dependencies <- c(map$dependencies, list(plugin))
  #   map
  # }

  
  
  ## MAIN LEAFLET MAP ###########
 
  
  
  output$transitmap <- renderLeaflet({
    leaflet() %>% 
      setView(lat = initlat, lng = initlong, zoom = initzoom) %>% 
      addPolylines(data = spldf.mor, fillOpacity =  1, 
                   stroke = T, 
                   weight = 5, 
                   color = 'blue')
    })
  
  ## OBSERVER FOR MAPPING ui VARIABLES ###########
  
  observe ({

    spldf <- spldfmaker(citychoice = as.character(input$city),
                        odchoice = as.character(input$od),
                        timechoice = as.character(input$moreve), 
                        pmchoice = as.character(input$pmetric))
    
    

    leafletProxy("transitmap") %>%
      clearShapes() %>%
      addProviderTiles(choosebasemap(input$moreve)) %>%
      addPolylines(data = spldf, 
                   fillOpacity =  1,
                   stroke = T, 
                   weight = 5, 
                   color = ~linecolor, 
                   highlightOptions = highlightOptions(stroke = T, 
                                                       color = 'black', 
                                                       weight = 2, 
                                                       bringToFront = T), 
                   label = ~htmltools::HTML(paste("<h2>", spldf@data[,3], "</h2>", 
                                  "<b>Avg. TT (mins):</b>", spldf@data[,4], "<br>", 
                                  "<b>Rel. TT (mins):</b>", spldf@data[,5], 
                                  sep = ""))) %>%
      addLegend('bottomleft', colors = colordf$linecolor,
                labels = colordf$bounds,
                title = paste('Average daily peak-period ', as.character(input$pmetric), sep = ''),
                layerId = 'legend') 
    })

  
  
})









