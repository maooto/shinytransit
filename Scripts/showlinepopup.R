showlinepopup <- function(corrcode, results, lat, lng) { 
  res <- results[results$corrcode == corrcode, ] 
  
  content <- as.character(tagList(
    tags$h5(res$Commute),
    tags$strong(HTML(sprintf("%s",res$period))), tags$br(),
    sprintf("Avg. TT: %s", res$`Average Travel Time`), tags$br(),
    sprintf("Rel. TT: %s%%", res$`Reliable Travel Time`)), tags$br(),
    sprintf("PMT: %s", res$PMT), tags$br(),
    sprintf("Avg. Occ'y: %s", res$`Avg. Occupancy`), tags$br(),
    sprintf("Daily Transit Trips: %s", res$`Daily Transit Trips`), tags$br(),
    sprintf(" % of daily Trips > 90% Occy': %s", res$`Trips w/ 90%+ Occupancy`), tags$br(),
    sprintf("GHG Avoided: %s", res$`GHG Avoided`), tags$br(),
    sprintf("VMT Avoided: %s", res$`VMT Avoided`)
  )
  
  leafletProxy("map") %>% addPopups(lng, lat, content, layerId = corrcode)
  
}

