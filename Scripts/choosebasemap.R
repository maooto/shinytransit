choosebasemap <- function(period) { 
  if(period == 'morning') { 
    mapchoice <- 'OpenStreetMap.BlackAndWhite' #'CartoDB.Positron'
  } else { 
    mapchoice <- 'CartoDB.DarkMatter'
  }
  
  return(mapchoice)
}