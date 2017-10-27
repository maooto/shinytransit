labelmaker <- function(results) { 
  
  labeldf <- data.frame(labels = rep('o', dim(results)[1]), stringsAsFactors = F)
  
  for (c in 1:dim(results)[1]) { 
    
    labeldf$labels[c] <- paste("<h5>", results$Commute[c], "</h5>",
                               "<b>Avg. TT (mins): </b>", format(round(results$`Average Travel Time`[c],2), nsmalls = 2), "<br>",
                               "<b>Rel. TT (mins): </b>", format(round(results$`Reliable Travel Time`[c],2), nsmalls = 2),"<br>",
                               "<b>PMT: </b>", format(round(results$PMT[c],2), nsmalls = 2),"<br>",
                               "<b>Ridership: </b>", format(round(results$Ridership[c],0), nsmalls = 0),"<br>",
                               "<b>Avg. Trip Occupancy: </b>", sprintf("%.01f%%", 100*results$`Avg. Occupancy`[c]),"<br>",
                               "<b>Daily Trips:</b>", format(round(results$`Daily Transit Trips`[c],0), nsmalls = 0),"<br>",
                               "<b>Trips w/ 90%+ Occ'y: </b>",sprintf("%.01f%%", 100*results$`Trips w/ 90%+ Occupancy`[c]),"<br>",
                               "<b>GHG Avoided (lbs CO2e): </b>", format(round(results$`GHG Avoided`[c],2), nsmalls = 2),"<br>",
                               "<b>VMT Avoided: </b>", format(round(results$`VMT Avoided`[c],2), nsmalls = 2),"<br>",
                               sep = "")
    
    
    
  }
 
  return(as.list(labeldf$labels))
  
}

