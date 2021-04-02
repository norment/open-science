### PLOT HERITABILITY ########################

#-- Libraries ------------------------

library(tidyverse)
library(normentR)

#-- Load data ------------------------

h2 <- read_delim("files/LDSC_h2.txt", delim = "\t", trim_ws = TRUE)

ic_defs <- read_delim("files/IC_names.txt", delim = "\t") %>%
  mutate(comp_label = str_glue("{component} ({comp_def})"))

#-- Prepare data ------------------------

plotdata <- h2 %>%
  mutate(IC = paste0(calc,component),
         h2_thres = ifelse(1.96*se < h2, h2, NA)) %>%
  right_join(ic_defs, by = c("IC" = "component"))

#-- Create plot ------------------------

plot <- ggplot(plotdata, aes(x = reorder(comp_label,h2), y = h2_thres, color = h2)) +
  geom_hline(yintercept = 0, color = "grey60") +
  geom_pointrange(aes(ymin = h2 - se, ymax = h2 + se), size = 1.2) +
  geom_segment(aes(xend = reorder(comp_label,h2), y = -0.001, yend = h2 - se - 0.001), 
               color = norment_colors[["light grey"]], size = 0.2) +
  labs(x = NULL,
       y = "Heritability (h2)",
       color = NULL) +
  scale_y_continuous(limits = c(-0.002,0.09), breaks = seq(0,0.09,0.02),
                     expand = c(0.01,0)) +
  scale_color_norment(discrete = FALSE, palette = "lajolla", 
                      limits = c(0,0.09), breaks = seq(0,0.09,0.02),
                      guide = guide_colorbar(nbin = 100, 
                                             title.position = "left", title.vjust = 1, 
                                             barheight = 0.5, barwidth = 16)) +
  theme_norment() +
  theme(
    panel.grid.major.y = element_blank(),
    plot.margin = margin(0.25,1,0.25,1,"cm")
  ) +
  coord_flip()
print(plot)

ggsave(plot, file = "figures/IC_heritability.png", width = 20, height = 12, units = "cm")

