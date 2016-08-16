library(shiny)
library(readr)

shinyUI(fluidPage(
    
    sidebarLayout(
        # Sidebar with user inputs
        sidebarPanel(
            textInput(inputId = 'name', 
                      label = 'Name', 
                      placeholder = 'Enter a Name Here'),
            
            selectInput(inputId = 'sex', 
                        label = 'Sex', 
                        choices = c('M', 'F'))
            
        ),
        
        # Show a plot
        mainPanel(
            plotOutput('plot1')
        )
    )
))
