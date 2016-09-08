library(ggplot2)
library(dplyr)
library(readr)

# Get top 10 names
top_10_names <- read_csv('/srv/shiny-server/census_names/input/top_10_each_year.csv')       # Server
#top_10_names <- read_csv('~/dev/shiny-projects/census_names/input/top_10_each_year.csv')   # Local
top_10_names$name <- factor(top_10_names$name)

shinyServer(function(input, output, session) {
        
    selected_data <- reactive({
        subset <- filter(top_10_names, sex == input$sex, year == input$year)
        subset$name <- factor(subset$name, levels = subset$name[order(-subset$count)])
        subset
    })
    
    output$plot1 <- renderPlot({
        data <- selected_data()
        sex_name <- ifelse(input$sex == 'F', 'Girls', 'Boys')
        
        ggplot(data, aes(x = name, y = count)) + 
            geom_bar(stat = 'identity') +
            ggtitle(paste('Most Common Names for', sex_name, 'in', input$year)) +
            xlab('') + 
            ylab('Number of Babies Born with Name\n') + 
            theme_bw() +
            theme(panel.border = element_blank(),
                  panel.grid = element_blank(),
                  axis.ticks = element_blank())
    })
    
})
