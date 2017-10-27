spldfmaker <- function(citychoice, odchoice, timechoice, pmchoice) { 
  
  #subset the spatial dataframe for plotting, given user inputs 
  
  od <- odhash[, c('corrcode', as.character(odchoice))]
  od1 <- od[od[,as.character(odchoice)] == as.character(citychoice), ]
  
  
  if (as.character(timechoice) == 'morning') { 
    spldf <- spldf.mor
    res <- resmor
    
  } else { 
    spldf <- spldf.eve  
    res <- reseve
  }
  
  res1 <- merge(res, od1, by = 'corrcode') 
  
  spldf <- spldf[spldf@data$corrcode%in% res1$corrcode, ] #the corresponding subset of the spldf
  
  print(c(citychoice, odchoice, timechoice, pmchoice))
  
  linecolors <- linecolormaker(spldf = spldf, pmchoice = pmchoice) # determine color the lines
  spldf@data <- merge(spldf@data, linecolors[, c('corrcode', 'linecolor')], by = 'corrcode')
  
  return(spldf)
}
