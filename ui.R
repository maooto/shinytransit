shinyUI(fluidPage(
  
  #Application Title
  navbarPage("NW Washington Transit Performance Dashboard [beta]", id = 'nav',
  
    tabPanel('Map', 
             div(class = 'outer', 
                 
                 leafletOutput("transitmap", height = 833.33), #, height = 833.33, width = 1000
                 
                 absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                               draggable = TRUE, top = 150, left = 20, right = "auto" , bottom = "auto",
                               width = 330, height = "auto",
                               
                               ### ui DASHBOARD CONTROLS 
                               selectInput("pmetric",
                                           "Select a performance metric:",
                                           choices = names(res[,c(4:12)])
                       
                               ),
                               selectInput("city", 
                                           "Select a city:", 
                                           choices = c('Auburn',
                                                       'Bellevue',
                                                       'Everett',
                                                       'Federal Way',
                                                       'Issaquah',
                                                       'Lacey',
                                                       'Lakewood',
                                                       'Lynnwood',
                                                       'Olympia',
                                                       'Redmond',
                                                       'Renton',
                                                       'SeaTac',
                                                       'Seattle',
                                                       'Tacoma',
                                                       'Tukwila')
                               ),
                               radioButtons("od", 
                                            paste("Examine the city as an origin or destination?"), 
                                            choices = c('Origin', 'Destination')
                               ),
                               radioButtons("moreve", 
                                            "View performance for:", 
                                            choiceNames = c('Morning peak-period commutes', 
                                                        'Evening peak-period commutes'), 
                                            choiceValues = c('morning', 'evening')
                               ),
                               helpText("Transit performance metrics result from analyzing multiple routes operated by multiple transit agencies, and do 
                                        not reflect the performance of any single entity or route.")
                               )
             )))))
                 
                 
     