### CREATE QQ-PLOT ########################

#-- Libraries -------------------------

library(tidyverse)
library(normentR)

#-- Load data ------------------------

ic_defs <- read_delim("files/IC_names.txt", delim = "\t") %>%
  mutate(comp_label = str_glue("{component} ({comp_def})"))

for (i in seq(11,nrow(ic_defs))) {
  
  print(str_glue("Running for IC{i}"))
  
  gwas.data <- read_delim(str_glue("sumstats/GWAS_IC{i}.glm.linear.fuma.gz"),
                          delim = "\t", col_types = cols())
  
  #-- Prepare data ------------------------
  
  prep.data <- gwas.data %>%
    filter(!is.na(PVAL))
  
  ci <- 0.95
  n  <- nrow(prep.data)
  
  plotdata <- data.frame(
    observed = -log10(sort(prep.data$PVAL)),
    expected = -log10(ppoints(n)),
    clower   = -log10(qbeta(p = (1 - ci) / 2, shape1 = 1:n, shape2 = n:1)),
    cupper   = -log10(qbeta(p = (1 + ci) / 2, shape1 = 1:n, shape2 = n:1))
  )
  
  plotdata_low <- plotdata %>%
    filter(expected <= 3) %>%
    sample_frac(0.005)
  
  plotdata_high <- plotdata %>%
    filter(expected > 3)
  
  plotdata_small <- bind_rows(plotdata_low, plotdata_high)
  
  #-- Create plot ------------------------
  
  qqplot <- ggplot(plotdata_small, aes(x = expected, y = observed)) +
    geom_ribbon(mapping = aes(ymin = clower, ymax = cupper), fill = "grey30", alpha = 0.5) +
    #geom_point(shape = 21, size = 2.5, alpha = 0.8, stroke = 0, fill = norment_colors[["purple"]]) +
    geom_step(color = norment_colors[["purple"]], size = 1.1, direction = "vh") +
    #geom_abline(intercept = 0, slope = 1, size = 1.25, alpha = 0.5, color = "grey30") +
    geom_segment(data = . %>% filter(expected == max(expected)), 
                 aes(x = 0, xend = expected, y = 0, yend = expected),
                 size = 1.25, alpha = 0.5, color = "grey30", lineend = "round") +
    labs(title = ic_defs %>% slice(i) %>% pull(comp_label),
         x = expression(paste("Expected -log"[10], plain(P))),
         y = expression(paste("Observed -log"[10], plain(P)))) +
    #coord_equal() +
    theme_norment() +
    theme()
  save(qqplot, file = str_glue("qqplots/qqplot_IC{i}.RData"))
  
}
