library(dplyr)
library(readr)
library(ggplot2)
setwd('~/dev/names/tracer')

# Get all names
names <- read_csv('../input/all_names.csv')

shinyServer(function(input, output, session) {
        
    selected_data <- reactive({
        subset <- filter(names, tolower(name) == tolower(input$name), sex == input$sex)
        subset
    })
    
    output$plot1 <- renderPlot({
        data <- selected_data()
        ggplot(data, aes(x = year, y = rank)) + 
            geom_line() +
            ggtitle(paste('Popularity of the name', input$name, 'since 1880')) +
            xlab('Year') + 
            ylab('Rank') + 
            scale_y_reverse() +
            theme_bw() +
            theme(panel.border = element_blank())
    })
    
})