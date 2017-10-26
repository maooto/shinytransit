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
  
  colordf <<- merge(colordf, mycolors, by = 'colbin') #bring in the color palette and pass colordf to global env
  
  ## NOW PUT USER-SELECTED DATA INTO THOSE BINS
  colors <- data.frame(colbin = as.numeric(cut(spldf@data[,as.character(pmchoice)], breaks = cutpoints)))
  colors <- merge(colors, mycolors, by = 'colbin')
  
  return(colors$linecolor)
  
}