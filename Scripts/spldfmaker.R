spldfmaker <- function(citychoice, odchoice, timechoice, pmchoice) { 
  
  #subset the spatial dataframe for plotting, given user inputs 
  
  od <- odhash[, c('corrcode', as.character(odchoice))]
  od1 <- od[od[,as.character(odchoice)] == as.character(citychoice), ]
  
  
  if (as.character(timechoice) == 'morning') { 
    spldf <- spldf.mor
    res1 <- merge(resmor, od1, by = 'corrcode') #GIVE all the morning results for that origin/destination city
    
  } else { 
    spldf <- spldf.eve  
    res1 <- merge(reseve, od1, by = 'corrcode') #OR all the evening results for that origin/destination city
  }
  
  
  spldf <- spldf[spldf@data$corrcode%in% res1$corrcode, ] #the corresponding subset of the spldf
  
  spldf@data$linecolor <- linecolormaker(spldf = spldf, results = res1, pmchoice = pmchoice) # determine color the lines
  spldf@data$labelstring <- labelmaker(results = res1) #make a text string for labels to be read by htmltools::HTML
  
  return(spldf)
}
