### CREATE MANHATTAN-PLOT FIGURE ########################

#-- Libraries -------------------------

library(tidyverse)
library(patchwork)
library(normentR)

#-- Load data ------------------------

plots <- list()
for (i in seq(13)) {
  print(str_glue("Loading manhattan plot for IC{i}"))
  load(str_glue("manhattan_plots/manhplot_IC{i}.RData"))
  plots[[i]] <- manhplot
}

#-- Create figure ------------------------

p <- (plots[[8]] + plots[[7]]) /
  (plots[[13]] + plots[[3]]) /
  (plots[[2]] + plots[[9]]) /
  (plots[[1]] + plots[[4]]) /
  (plots[[11]] + plots[[6]]) /
  (plots[[5]] + plots[[12]]) /
  (plots[[10]] + plot_spacer()) &
  theme_norment(plot_title_size = 10, legend = FALSE) +
  theme( 
    plot.tag = element_text(size = 0),
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.text.x = element_text(angle = 90, size = 4, vjust = 0.5)
  )

print("Saving Manhattan figure")
system.time(
  ggsave(p, filename = "figures/manhattan_all.png", width = 12, height = 18, limitsize = FALSE)
)

