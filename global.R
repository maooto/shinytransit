####### 0 - setup #############

library(stringr)
library(googleway)
library(jsonlite)
library(ggplot2)
library(shiny)
library(htmlwidgets)
library(htmltools)
library(plyr)
library(rsconnect)
library(devtools)
library(maptools)
library(arules)
library(leaflet)
library(rgdal)
library(arules)


source('./Scripts/linecolormaker.R')
source('./Scripts/spldfmaker.R')
source('./Scripts/choosebasemap.R')
source('./Scripts/labelmaker.R')

initlat <- 47.642137
initlong <- -122.253325
initzoom <- 9

mycolors <- data.frame(colbin = c(1:4),
                       linecolor = as.character(c('#74add1',
                                              '#f4a582',
                                              '#d6604d',
                                              '#b2182b')))

# # ####### 1 - READ PERFORMANCE DATA #############
cityloc <- read.csv(file = './Data/cityloc.csv')
odhash <- read.csv(file = './Data/odhash.csv', stringsAsFactors = F)
res <- read.csv(file = './Data/transitrawresults082417.csv', stringsAsFactors = F)


names(res) <- c('corrcode', 'period', 'Commute', 'Average Travel Time', 'Reliable Travel Time', 'Ridership', 'PMT',
                'Avg. Occupancy', 'Daily Transit Trips', 'Trips w/ 90%+ Occupancy', 'GHG Avoided', 'VMT Avoided')

#store master copy
res_original <- res

#morning/evening subsets
#(so that corrcode is unique line/layer ID)
resmor <- res[res$period == 'morning', ]
reseve <- res[res$period == 'evening', ]


####### READ SHAPE DATA #############

#initiate
corrlist <- unique(res$corrcode) #use unique(res$corrcode) when all polylines are ready to import
shapelist <- list(NULL)
fortlist <- list(NULL)

#loop to read all shape layers
#google maps KML
for (c in 1:length(corrlist)) {

  shapelist[[c]] <- rgdal::readOGR(dsn = './Data/TransitDB-commutes', as.character(corrlist[c]))

  fortlist[[c]] <- fortify(shapelist[[c]])

  fortlist[[c]]$corrcode <- corrlist[c]

}

fortlines <- do.call('rbind', fortlist) #dataframe for lines
fortlines <- fortlines[ , !(names(fortlines) %in% c('order', 'piece', 'id', 'group'))] #remove extraneous columns


# A mystery step
# code adapted from: http://rpubs.com/bhaskarvk/leaflet-shipping
corrlines.grouped <- fortlines %>%
  dplyr::group_by(corrcode) %>% tidyr::nest()

# Generate a SpatialLines class
purrr::map(
  1:nrow(corrlines.grouped), # because we need to generate a unique ID for a line.
  function(rowNum) {
    sp::Lines(list(sp::Line(corrlines.grouped$data[[rowNum]])), ID = rowNum)
  }) %>%
  sp::SpatialLines(
    proj4string =
      sp::CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')) -> corr.lines

row.names(corr.lines) <- corrlist

#combine attributes/lines into spatial lines dataframe
spldf.mor <- sp::SpatialLinesDataFrame(corr.lines, resmor, match.ID = 'corrcode')

spldf.eve <- sp::SpatialLinesDataFrame(corr.lines, reseve, match.ID = 'corrcode')











