### CREATE MANHATTAN-PLOT ########################

#-- Libraries -------------------------

library(tidyverse)
library(normentR)

#-- Load data -------------------------

ic_defs <- read_delim("files/IC_names.txt", delim = "\t") %>%
  mutate(comp_label = str_glue("{component} ({comp_def})"))

for (ic in seq(13)) {
  
  print(str_glue("Running for IC{ic}"))
  
  gwas.data <- read_delim(str_glue("/GWAS_IC{ic}.glm.linear.fuma.gz"),
                          delim = "\t", col_types = cols())
  
  #-- Prepare data -------------------------
  
  sig.dat <- gwas.data %>% 
    filter(PVAL < 0.05)
  
  notsig.dat <- gwas.data %>% 
    filter(PVAL >= 0.05) %>%
    sample_frac(size = 0.01)
  
  gwas.data <- bind_rows(sig.dat,notsig.dat)
  
  #-- Get cumulative BP position -------------------------
  
  nCHR <- length(unique(gwas.data$CHR))
  gwas.data$BPcum <- as.double(NA)
  s <- 0
  nbp <- c()
  for (i in unique(gwas.data$CHR)){
    nbp[i] <- max(gwas.data[gwas.data$CHR == i,]$BP)
    gwas.data[gwas.data$CHR == i,"BPcum"] <- gwas.data[gwas.data$CHR == i,"BP"] + s
    s <- s + nbp[i]
  }
  
  #-- Plot settings -------------------------
  
  axis.set <- gwas.data %>% 
    group_by(CHR) %>% 
    summarize(center = (max(BPcum) + min(BPcum)) / 2)
  
  ylim <- abs(floor(log10(min(gwas.data$PVAL)))) + 2 
  sig <- 5e-8
  
  #-- Create plot -------------------------
  
  manhplot <- ggplot(gwas.data, aes(x = BPcum, y = -log10(PVAL), 
                                    color = as.factor(CHR), size = -log10(PVAL))) +
    geom_point(size = 0.5, alpha = 0.75) +
    geom_hline(yintercept = -log10(sig), color = "grey40", linetype = "dashed") + 
    scale_x_continuous(label = axis.set$CHR, breaks = axis.set$center) +
    scale_y_continuous(expand = c(0,0), limits = c(0, ylim)) +
    scale_color_manual(values = rep(c(norment_colors[["purple"]], norment_colors[["magenta"]]), nCHR)) +
    scale_size_continuous(range = c(0.5,3)) +
    labs(title = ic_defs %>% slice(ic) %>% pull(comp_label),
         x = NULL, 
         y = "-log10(p)") + 
    theme_norment() +
    theme( 
      legend.position = "none",
      panel.border = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank(),
      axis.text.x = element_text(angle = 90, size = 4, vjust = 0.5)
    )
  save(manhplot, file = str_glue("manhattan_plots/manhplot_IC{ic}.RData"))
  
}

