### PLOT LDSC CORRELATION MATRIX FOR DICHOTOMOUS IC2 ########################

#-- Libraries ------------------------

library(tidyverse)
library(normentR)

#-- Load data ------------------------

ldsc_all <- read.table("files/LDSC_stats.txt", header = TRUE) 

ldsc_ic2 <- ldsc_all %>%
  mutate(p.fdr = p.adjust(p, method = "fdr")) %>%
  filter(component == "IC2") %>%
  mutate(component_label = "IC2 (continuous)")

ldsc_ic2dich <- read.table("files/LDSC_stats_IC2dich.txt", header = TRUE) %>%
  mutate(component_label = "IC2 (dichotomous)")

dich_adj_p <- ldsc_all %>%
  filter(!(component == "IC2")) %>%
  pull(p) %>%
  c(.,ldsc_ic2dich$p) %>%
  p.adjust(., method = "fdr") %>%
  .[seq(length(.)-8,length(.))]

ldsc_ic2dich <- ldsc_ic2dich %>%
  mutate(p.fdr = dich_adj_p)

ldsc <- bind_rows(ldsc_ic2, ldsc_ic2dich)

GWAS_names <- read_delim("files/GWAS_names.txt", delim = "\t")

#-- Prepare data ------------------------

plotdata <- ldsc %>%
  mutate(rg_inv = ifelse(str_detect(component_label,"continuous"), rg * -1, rg)) %>%
  inner_join(GWAS_names, by = "diagnosis")

mancheck <- plotdata %>%
  select(component_label, diagnosis_new, rg_inv, se, p.fdr)

#-- Create plot ------------------------

ggplot(plotdata, aes(x = reorder(diagnosis_new, -abs(rg_inv)), 
                     y = reorder(component_label, abs(rg_inv)), fill = rg_inv)) +
  geom_point(shape = 22, aes(size = se), color = "transparent") +
  geom_point(data = . %>% filter(p.fdr < 0.05), aes(size = se), 
             shape = 22, color = "black", stroke = 1.5) +
  geom_text(aes(label = round(rg_inv,2))) +
  labs(x = NULL,
       y = NULL,
       fill = bquote("Genetic Correlation"~(r[g])),
       size = "Standard Error") +
  scale_x_discrete(position = "top") +
  scale_fill_norment(discrete = FALSE, palette = "vik", limits = c(-1,1),
                     guide = guide_colorbar(nbin = 100, barheight = 0.75, barwidth = 20, reverse = FALSE, 
                                            direction = "horizontal", 
                                            ticks = FALSE, title.vjust = 1, order = 1)) +
  scale_size_continuous(range = c(11,25), trans = "reverse",
                        guide = guide_legend(order = 2, nrow = 1, direction = "horizontal", label.position = "bottom",
                                             override.aes = list(fill = "grey80"))) +
  coord_equal() +
  theme_norment(base_size = 12, axis_title_size = 14, grid = FALSE) +
  theme(
    legend.position = "bottom",
    legend.box = "vertical",
    axis.text = element_text(colour = "black"),
    axis.text.x = element_text(angle = 30, hjust = 0),
    #plot.margin = grid::unit(c(0,0,0,0),"cm")
  )
ggsave("figures/LDSC_IC2_contxdich.png", height = 6, width = 12, dpi = 600, bg = "white")



