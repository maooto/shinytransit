labelmaker <- function(results) { 
  
  labeldf <- data.frame(labels = rep('o', dim(results)[1]), stringsAsFactors = F)
  
  for (c in 1:dim(results)[1]) { 
    
    labeldf$labels[c] <- paste("<h5>", results$Commute[c], "</h5>",
                               "<b>Avg. TT (mins):</b>", results$`Average Travel Time`[c], "<br>",
                               "<b>Rel. TT (mins):</b>", results$`Reliable Travel Time`[c],
                               sep = "")
    
    
    
  }
 
  return(as.list(labeldf$labels))
  
}