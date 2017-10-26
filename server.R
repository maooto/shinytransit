
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


  ## DEFINE FUNCTIONS #############
  
  choosebasemap <- function(period) { 
    if(period == 'morning') { 
      mapchoice <- 'OpenStreetMap.BlackAndWhite' #'CartoDB.Positron'
    } else { 
      mapchoice <- 'CartoDB.DarkMatter'
    }
    
    return(mapchoice)
  }
  
  
  
  spldfmaker <- function(citychoice, odchoice, timechoice, pmchoice) { 
    
    source('./Scripts/linecolormaker') 
    spldf@data$linecolor <- linecolormaker(pmchoice = pmchoice, timechoice = timechoice)
    
    #subset the spatial dataframe for plotting, given user inputs 
    
    od <- odhash[, c('corrcode', as.character(odchoice))]
    
    od1 <- od[od[,as.character(odchoice)] == as.character(citychoice), ]
    
    
    if (as.character(timechoice) == 'morning') { 
      spldf <- spldf.mor
      res1 <- merge(resmor, od1, by = 'corrcode')
      
    } else { 
      spldf <- spldf.eve  
      res1 <- merge(reseve, od1, by = 'corrcode')
    }
    
    res2 <- res1[res1$period == as.character(timechoice), ] #the subset of results the user wants to plot 
    
    spldf <- spldf[spldf@data$corrcode%in% res2$corrcode, ] #the corresponding subset of the spldf
    
    source('./Scripts/linecolormaker') 
    spldf@data$linecolor <- linecolormaker(pmchoice = pmchoice, timechoice = timechoice) #color the lines
    
    return(spldf)
  }

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
                             timechoice = as.character(input$moreve))
    
    

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









