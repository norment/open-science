### LDSC CORRELATION MATRIX DIAG x DIAG ########################

#-- Libraries -------------------------

library(tidyverse)
library(normentR)

#-- Load data ------------------------

ldsc <- read.table("files/LDSC_stats_DIAGxDIAG.txt", header = TRUE) %>%
  mutate(p.fdr = p.adjust(p, method = "fdr"),
         p.bonf = p.adjust(p, method = "bonferroni"))

GWAS_names <- read_delim("files/GWAS_names.txt", delim = "\t")

#-- Prepare data ------------------------

plotdata <- ldsc %>%
  inner_join(GWAS_names, by = c("DIAG1" = "diagnosis")) %>%
  rename(diagnosis_new_x = diagnosis_new) %>%
  inner_join(GWAS_names, by = c("DIAG2" = "diagnosis")) %>%
  rename(diagnosis_new_y = diagnosis_new)

limits <- GWAS_names %>%
  slice(3,4,2,1,6,5,7,8,9) %>%
  pull(diagnosis_new)

#-- Create plot ------------------------

DxD_plot <- ggplot(plotdata, aes(x = diagnosis_new_x, y = diagnosis_new_y, fill = rg)) +
  geom_point(shape = 22, aes(size = se), color = "transparent") +
  geom_point(data = . %>% filter(p.fdr < 0.05), aes(size = se), 
             shape = 22, color = "black", stroke = 1.5) +
  geom_point(data = data.frame(diagnosis_new_x = limits, 
                               diagnosis_new_y = limits), 
             size = 25, shape = 22, fill = "grey50", color = "transparent") +
  geom_text(aes(label = round(rg,2)), size = 3) +
  labs(x = NULL,
       y = NULL,
       fill = bquote("Genetic Correlation"~(r[g])),
       size = "Standard Error") +
  scale_x_discrete(position = "top", limits = limits) +
  scale_y_discrete(limits = limits) +
  scale_fill_norment(discrete = FALSE, palette = "vik", limits = c(-1,1),
                     guide = guide_colorbar(order = 2, nbin = 100, barwidth = 0.75, barheight = 15, ticks = FALSE)) +
  scale_size_continuous(range = c(6,20), trans = "reverse",
                        guide = guide_legend(order = 1, override.aes = list(fill = "grey80"))) +
  coord_equal() +
  theme_norment(base_size = 12, axis_title_size = 14, grid = FALSE) +
  theme(
    legend.position = c(0.8,0.3),
    legend.box = "horizontal",
    legend.box.just = "bottom",
    legend.title = element_text(vjust = 0.5),
    axis.text = element_text(colour = "black"),
    axis.text.x = element_text(hjust = 0, angle = 30),
    plot.margin = margin(1,3,1,1,"cm")
  )
print(DxD_plot)
ggsave("figures/LDSC_DIADxDIAG.png", DxD_plot, height = 8, width = 10, dpi = 600, bg = "white")


