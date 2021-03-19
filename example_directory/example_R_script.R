### EXAMPLE R SCRIPT ########################

#-- Libraries -------------------------

library(tidyverse)

#-- Load data ------------------------

data <- palmerpenguins::penguins

#-- Create plot ------------------------

ggplot(data, aes(x = flipper_length_mm)) +
  geom_histogram(aes(fill = species), alpha = 0.5, position = "identity") +
  scale_fill_manual(values = c("darkorange","darkorchid","cyan4")) + 
  theme_minimal()
