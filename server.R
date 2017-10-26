
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
  
  linecolormaker <- function(pmchoice, timechoice) { 
    
    if (as.character(timechoice) == 'moring') {
      res <- resmor
      spldf <- spldf.mor 
    } else { 
      res <- reseve
      spldf <- spldf.eve  
    }
    
    
    ## FIRST DETERMINE CUTPOINTS FOR THE COLOR LEGEND 
    ## BASED ON THE USER-CHOSEN PERFORMANCE METRIC 
    colorcats <- 4 #of color categories
    
    cutpoints <- unique(arules::discretize(seq(0,max(res[, as.character(pmchoice)], na.rm = T),1), 
                              categories = colorcats, 
                              method = "interval", 
                              onlycuts = T)) #to return as a vector of cut points
    
    
    #same cuts but as df w/ lables for legend
    colordf <- data.frame(bounds = as.character(unique(arules::discretize(seq(0,max(res[, as.character(pmchoice)], na.rm = T),1), 
                                                             categories = colorcats, 
                                                             method = "interval"))), 
                          colbin = seq(1,colorcats,1))
    
    colordf <<- merge(colordf, mycolors, by = 'colbin') #bring in the color palette and pass colordf outside of functn 
    
    ## NOW PUT USER-SELECTED DATA INTO THOSE BINS
    colors <- data.frame(colbin = as.numeric(cut(spldf@data[,as.character(pmchoice)], breaks = cutpoints)))
    colors <- merge(colors, mycolors, by = 'colbin')
    
    return(colors$linecolor)
    
  }
  
  spldfmaker <- function(citychoice, odchoice, timechoice) { 
    
    #subset the spatial dataframe for plotting, given user inputs 
    
    od <- odhash[, c('corrcode', as.character(odchoice))]
    
    od1 <- od[od[,as.character(odchoice)] == as.character(citychoice), ]
    
    
    if (as.character(timechoice) == 'morning') { 
      spldf <- spldf.mor
      res1 <- merge(res, od1, by = 'corrcode')
      
    } else { 
      spldf <- spldf.eve  
      res1 <- merge(reseve, od1, by = 'corrcode')
    }
    
    res2 <- res1[res1$period == as.character(timechoice), ]
    
    spldf <- spldf[spldf@data$corrcode%in% res2$corrcode, ]
    
    return(spldf)
  }

  ## MAIN LEAFLET MAP ###########
 
  
  
  output$transitmap <- renderLeaflet({
    leaflet() %>% 
      setView(lat = initlat, lng = initlong, zoom = initzoom) %>% 
      addPolylines(data = spldf.mor, fillOpacity =  1, 
                   stroke = T, 
                   weight = 5, 
                   color = linecolormaker(pmchoice = input$pmetric, timechoice = input$moreve))
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
                   color = linecolormaker(pmchoice = input$pmetric, timechoice = input$moreve), 
                   highlightOptions = highlightOptions(stroke = T, 
                                                       color = 'black', 
                                                       weight = 2, 
                                                       bringToFront = T)) %>%
      addLegend('bottomleft', colors = colordf$linecolor,
                labels = colordf$bounds,
                title = paste('Average daily peak-period ', as.character(input$pmetric), sep = ''),
                layerId = 'legend') 
    })

  
  
})









