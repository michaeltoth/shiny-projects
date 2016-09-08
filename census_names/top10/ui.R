library(shiny)
library(readr)

top_10_names <- read_csv('/srv/shiny-server/census_names/input/top_10_each_year.csv')       # Server
#top_10_names <- read_csv('~/dev/shiny-projects/census_names/input/top_10_each_year.csv')   # Local

shinyUI(fluidPage(
    
    sidebarLayout(
        # Sidebar with user inputs
        sidebarPanel(
            sliderInput(inputId = 'year', 
                        label = 'Year', 
                        min = min(top_10_names$year),
                        max = max(top_10_names$year),
                        value = min(top_10_names$year),
                        sep = '',
                        animate = T),
            
            selectInput(inputId = 'sex', 
                        label = 'Sex', 
                        choices = unique(top_10_names$sex))
        ),
        
        # Show a plot
        mainPanel(
            plotOutput('plot1')
        )
    )
))
