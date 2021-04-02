##### DICHOTOMIZE PSYCHOSIS COMPONENT #########################

#-- Libraries -------------------------

library(tidyverse)

#-- Load data -------------------------

data <- read_csv("../files/ica_loadings_plink.csv")

#-- Load data -------------------------

IC2data <- data %>%
  select("IID","FID",contains("IC2")) %>%
  mutate(r = round(IC2,1))

IC2summ <- IC2data %>%
  group_by(r) %>%
  summarise(n = n())

#-- Plot distribution -------------------------

ggplot(IC2summ,aes(x = r, y = n)) +
  geom_rect(aes(xmin = min(r), xmax = max(r), ymin = 0, ymax = 6e4), fill = "yellow", alpha = 0.25) +
  geom_rect(aes(xmin = -1, xmax = 1, ymin = 0, ymax = 6e4), fill = "olivedrab", alpha = 0.25) +
  geom_bar(stat = "identity") + 
  theme_minimal()

#-- Get parameters -------------------------

threshold <- -1

IC2data <- IC2data %>%
  mutate(IC2_dich = ifelse(IC2 > threshold, 1, 2))

IC2data %>%
  group_by(IC2_dich) %>%
  summarise(n = n())

#-- Write to file -------------------------

to_write <- IC2data %>%
  select(FID,IID,IC2_dich)

write_csv(to_write, "../files/IC2_dich.csv")

