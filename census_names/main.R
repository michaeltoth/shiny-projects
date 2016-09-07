library(dplyr)
library(readr)
library(ggplot2)
setwd('~/dev/shiny-projects/census_names/')

# Get first year
names <- read_csv('input/yob1880.txt', col_names = c('name', 'sex', 'count'), col_types = cols(col_character(), col_character(), col_number()))
names$year <- 1880

# Get all years
for(year in seq(1881, 2015)) {
    print(paste0('Loading names for year: ', year))
    
    current <- read_csv(paste0('input/yob', year, '.txt'), col_names = c('name', 'sex', 'count'), col_types = cols(col_character(), col_character(), col_number()))
    current$year <- year
    
    names <- rbind(names, current) # Combine into single dataset
}

# Perform Aggregations
names <- names %>% 
         group_by(year, sex) %>% 
         mutate(rank = seq_along(name),
                proportion = count / sum(count))

top_10_each_year <- names %>% group_by(year, sex) %>% top_n(n = 10, wt = count)

# Write results to be used by Shiny apps
write.csv(top_10_each_year, 'input/top_10_each_year.csv', row.names = F)
write.csv(names, 'input/all_names.csv', row.names = F)



# Animation
