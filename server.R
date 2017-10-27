
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
      setView(lat = initlat, lng = initlong, zoom = initzoom)  
      # addPolylines(data = spldf.mor, fillOpacity =  1, 
      #              stroke = T, 
      #              weight = 5, 
      #              color = 'blue')
    })
  
  
  ## OBSERVER FOR popup data table ###########
  
  observe({
    leafletProxy("transitmap") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    isolate({
      showlinepopup(event$id, event$lat, event$lng)
    })
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
                   opacity = .8, 
                   stroke = T, 
                   weight = 6, 
                   color = ~spldf@data$linecolor, 
                   highlightOptions = highlightOptions(stroke = T,
                                                       #color = spldf@data$linecolor,
                                                       opacity = 1,
                                                       weight = 10,
                                                       bringToFront = T), 
                   layerId = ~spldf@data$corrcode
                   #label = ~htmltools::HTML(spldf@data$labelstring)
                   ) %>%
      addLegend('bottomleft', colors = colordf$linecolor,
                labels = colordf$bounds,
                title = paste('Average daily peak-period ', as.character(input$pmetric), sep = ''),
                layerId = 'legend') 
    })

  
  
})
