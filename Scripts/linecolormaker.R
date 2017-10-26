linecolormaker <- function(spldf, results, pmchoice) { 
  
  ## FIRST DETERMINE CUTPOINTS FOR THE COLOR LEGEND 
  ## BASED ON THE USER-CHOSEN PERFORMANCE METRIC 
  colorcats <- 4 #of color categories
  
  upperbound <- max(results[, as.character(pmchoice)], na.rm = T) + 1
  
  
  cutpoints <- unique(arules::discretize(seq(0, upperbound,1), 
                                         categories = colorcats, 
                                         method = "interval", 
                                         onlycuts = T)) #to return as a vector of cut points
  
  
  #same cuts but as df w/ lables for legend
  colordf <- data.frame(bounds = as.character(unique(arules::discretize(seq(0, upperbound ,1), 
                                                                        categories = colorcats, 
                                                                        method = "interval"))), 
                        colbin = seq(1,colorcats,1))
  
  colordf <<- merge(colordf, mycolors, by = 'colbin') #bring in the color palette and pass colordf to global env
  
  ## NOW PUT USER-SELECTED DATA INTO THOSE BINS
  colors <- data.frame(colbin = as.numeric(cut(spldf@data[,as.character(pmchoice)], breaks = cutpoints)))
  colors <- merge(colors, mycolors, by = 'colbin')
  
  return(colors$linecolor)
  
}