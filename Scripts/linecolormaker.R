linecolormaker <- function(spldf, pmchoice) { 
  
  ## FIRST DETERMINE CUTPOINTS FOR THE COLOR LEGEND 
  ## BASED ON THE USER-CHOSEN PERFORMANCE METRIC 
  colorcats <- dim(mycolors)[1] #of color categories
  
  upperbound <- (max(res_original[, as.character(pmchoice)], na.rm = T) + 1) #using res_original for global (all day) scale
  
  cutpoints <- unique(arules::discretize(seq(0, upperbound, .25), 
                                         categories = colorcats, 
                                         method = "interval", 
                                         onlycuts = T)) #to return as a vector of cut points
  
  
  #same cuts but as df w/ lables for legend
  colordf <- data.frame(bounds = as.character(unique(arules::discretize(seq(0, upperbound ,.25), 
                                                                        categories = colorcats, 
                                                                        method = "interval"))), 
                        colbin = seq(1,colorcats,1))
  
  colordf <<- merge(colordf, mycolors, by = 'colbin') #bring in the color palette and pass colordf to global env (for legend)
  
  ## NOW PUT USER-SELECTED DATA INTO THOSE BINS
  ## Note edge cases :
  # 1) data to visualize is null 
  # 2) data has at least one 0 value for pmetric 
 
  resbins <- spldf@data[, c('corrcode', as.character(pmchoice))]
  #  data.frame(pmetric = spldf@data[, as.character(pmchoice)])
  
  #resbins <- data.frame(pmetric = restest[, c('Trips w/ 90%+ Occupancy')])
                        
  resbins$binnum <- as.numeric(cut(spldf@data[,as.character(pmchoice)], breaks = cutpoints))
  #resbins$binnum <- as.numeric(cut(resbins$pmetric, breaks = cutpoints))
  
  resbins$binnum[resbins$pmetric == 0] <- 1 #deal w/ edge case 2 - put it in the bottom bin
  
  resbins <- merge(resbins, mycolors, by.x = 'binnum', by.y = 'colbin', all.x = T)
  
  resbins$linecolor[is.na(resbins$pmetric) == T] <- 'black' #deal w/ edge case 1 - draw a black line instead 

  return(resbins)
         
}