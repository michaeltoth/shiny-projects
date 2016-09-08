library(shiny)
library(readr)

shinyUI(fluidPage(
    
    sidebarLayout(
        # Sidebar with user inputs
        sidebarPanel(
            textInput(inputId = 'name', 
                      label = 'Enter a Name', 
                      value = 'Michael'),
            
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
