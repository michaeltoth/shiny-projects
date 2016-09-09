library(dplyr)
library(ggplot2)
library(gganimate) #devtools::install_github("dgrtwo/gganimate")
library(readr)
library(scales)

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
p <- ggplot(top_10_each_year, aes(x = proportion, y = count)) +
    #geom_point(aes(cumulative = T), size = 4) +
    geom_point(color = '#cccccc', size = 4, alpha = .10) +
    geom_point(aes(color = sex, frame = year), size = 4) +
    xlab('Proportion of Babies Born') +
    ylab('Number of Babies Born') +
    scale_color_manual(values = c('#ff99ff', '#66ccff')) +
    scale_x_continuous(labels = percent) + 
    theme_bw() +
    theme(panel.border = element_blank(),
          panel.grid = element_blank(),
          legend.position = 'none',
          axis.ticks = element_blank())

gg_animate(p, interval = 0.2, ani.width = 800, ani.height = 400)

# Based on https://gist.github.com/thomasp85/c8e22be4628e4420d4f66bcc6c88ac87
# Which created https://twitter.com/thomasp85/status/694905779539812352
# TODO: Make this into a function for tothr
anim <- lapply(1:10, function(i) {top_10_each_year$year <- top_10_each_year$year + i; top_10_each_year$fade <- 1 / (i + 2); top_10_each_year})
top_10_each_year$fade <- 1
top_10_each_year <- rbind(top_10_each_year, do.call(rbind, anim))

top_10_each_year <- filter(top_10_each_year, year <= 2015)

p2 <- ggplot(top_10_each_year, aes(x = proportion, y = count, color = sex, frame = year, alpha = fade)) +
    geom_point(size = 4) +
    xlab('Proportion of Babies Born') +
    ylab('Number of Babies Born') +
    scale_color_manual(values = c('#ff99ff', '#66ccff')) +
    scale_x_continuous(labels = percent) + 
    theme_bw() +
    theme(panel.border = element_blank(),
          panel.grid = element_blank(),
          legend.position = 'none',
          axis.ticks = element_blank())

gg_animate(p2, interval = 0.2, ani.width = 800, ani.height = 400)