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


# Based on https://gist.github.com/thomasp85/c8e22be4628e4420d4f66bcc6c88ac87
# Which created https://twitter.com/thomasp85/status/694905779539812352
anim <- lapply(1:10, function(i) {top_10_each_year$year <- top_10_each_year$year + i; top_10_each_year$fade <- 1 / (i + 2); top_10_each_year})
top_10_each_year$fade <- 1
top_10_with_fade <- rbind(top_10_each_year, do.call(rbind, anim))
top_10_with_fade <- filter(top_10_with_fade, year <= 2015)

p <- ggplot(top_10_with_fade, aes(x = proportion, y = count)) +
    geom_point(color = '#e6e6e6', size = 4) +
    geom_point(aes(color = sex, frame = year, alpha = fade), size = 4) +
    ggtitle('Top 10 Male & Female Baby Names\nYear:') +
    xlab('\nProportion (by sex) Born with Name') +
    ylab('Number Born with Name') +
    scale_color_manual(name = '', values = c('#ff7f00', '#377eb8'), labels = c('Female', 'Male')) +
    scale_x_continuous(labels = percent) + 
    scale_y_continuous(labels = comma) +
    scale_alpha(guide = 'none') + # Remove alpha legend from plot output
    theme_bw() +
    theme(panel.border = element_blank(),
          panel.grid = element_blank(),
          axis.ticks = element_blank(),
          legend.key = element_blank(),
          legend.position = 'bottom',
          axis.text = element_text(size = 14),
          axis.title = element_text(size = 16),
          legend.text = element_text(size = 12))

gg_animate(p, filename = 'yearly-birth-names-with-trails.gif', interval = 0.2, ani.width = 800, ani.height = 600)
#gg_animate(p, interval = 0.2, ani.width = 800, ani.height = 600)
