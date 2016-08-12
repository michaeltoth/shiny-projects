library(shiny)
library(readr)

top_10_names <- read_csv('../input/top_10_each_year.csv')

shinyUI(fluidPage(
    
    sidebarLayout(
        # Sidebar with user inputs
        sidebarPanel(
            selectInput(inputId = 'year', 
                        label = 'Year', 
                        choices = unique(top_10_names$year)),
            
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