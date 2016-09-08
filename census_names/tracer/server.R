library(dplyr)
library(readr)
library(ggplot2)
library(tothr) # devtools::install_github('michaeltoth/tothr')

# Get all names
names <- read_csv('/srv/shiny-server/census_names/input/all_names.csv')         # Server
#names <- read_csv('~/dev/shiny-projects/census_names/input/all_names.csv')     # Local

shinyServer(function(input, output, session) {
        
    selected_data <- reactive({
        subset <- filter(names, tolower(name) == tolower(input$name), sex == input$sex)
        subset
    })
    
    output$plot1 <- renderPlot({
        data <- selected_data()
        ggplot(data, aes(x = year, y = count)) + 
            geom_line() +
            ggtitle(paste('Popularity of the name', toupper_first(input$name), 'since 1880')) +
            xlab('Year') + 
            ylab('Number of Babies Born with Name\n') + 
            theme_bw() +
            theme(panel.border = element_blank())
    })
    
})
