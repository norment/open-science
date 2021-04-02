### PLOT LDSC CORRELATION MATRIX ########################

#-- Libraries ------------------------

library(tidyverse)
library(normentR)

#-- Functions ------------------------

reorder_within <- function(x, by, within, fun = mean, sep = "___", ...) {
  new_x <- paste(x, within, sep = sep)
  stats::reorder(new_x, by, FUN = fun)
}

scale_x_reordered <- function(..., sep = "___") {
  reg <- paste0(sep, ".+$")
  scale_x_discrete(labels = function(x) gsub(reg, "", x), ...)
}

#-- Load data ------------------------

ldsc <- read.table("files/LDSC_stats.txt", header = TRUE) %>%
  mutate(p.fdr = p.adjust(p, method = "fdr"),
         p.bonf = p.adjust(p, method = "bonferroni"))

gwas_names <- read_delim("files/GWAS_names.txt", delim = "\t")
ic_defs <- read_delim("files/IC_names.txt", delim = "\t") %>%
  mutate(comp_label = str_glue("{component} ({comp_def})"))

#-- Prepare data ------------------------

plotdata <- ldsc %>%
  right_join(gwas_names, by = "diagnosis") %>%
  right_join(ic_defs, by = "component") %>%
  mutate(rg_inv = rg * trans,
         comp_new = paste0("IC",parse_number(comp_label)))

plotdata <- plotdata %>%
  mutate(comp_new = fct_reorder(comp_new,parse_number(comp_label)),
         comp_def = fct_reorder(comp_def,parse_number(comp_label)),
         comp_new = fct_drop(comp_new),
         comp_def = fct_drop(comp_def),
         diagnosis_new = case_when(diagnosis_new == "Intelligence" ~ "COG",
                                   diagnosis_new == "Educational attainment" ~ "EDU",
                                   TRUE ~ diagnosis_new))

#-- Create plots ------------------------

p <- ggplot(plotdata, aes(x = reorder_within(diagnosis_new,-abs(rg), comp_new), 
                          y = 1, fill = rg_inv)) +
  geom_point(shape = 22, aes(size = se), color = "transparent") +
  geom_point(data = . %>% filter(p.fdr < 0.05), aes(size = se), 
             shape = 22, color = "black", stroke = 1.5) +
  geom_text(aes(label = diagnosis_new),  vjust = -0.5, fontface = "bold") +
  geom_blank(aes(label = comp_new)) +
  geom_text(aes(label = sprintf("(%s)",round(rg_inv,2))), vjust = 1) +
  labs(x = "Rank",
       y = NULL,
       fill = bquote("Genetic correlation "~(r[g])),
       size = "Standard Error",
       caption = bquote("Genetic correlation"~(r[g])~"shown in brackets below")) +
  scale_discrete_identity(
    aesthetics = "label",
    name = NULL,
    breaks = levels(plotdata$comp_new),
    labels = levels(plotdata$comp_def),
    guide = "legend"
  ) +
  scale_x_reordered(position = "top") +
  scale_y_continuous(labels = NULL) +
  scale_fill_norment(discrete = FALSE, palette = "vik", limits = c(-1,1),
                     guide = guide_colorbar(nbin = 100, barheight = 0.75, barwidth = 15, reverse = FALSE, 
                                            direction = "horizontal", 
                                            ticks = FALSE, title.vjust = 1, order = 2)) +
  scale_size_continuous(range = c(6,20), trans = "reverse",
                        guide = guide_legend(order = 3, direction = "horizontal", label.position = "bottom",
                                             override.aes = list(fill = "grey80"))) +
  guides(label = guide_legend(order = 1, keywidth = 2, nrow = 5, key.hjust = 1, override.aes = list(size = 4))) +
  theme_norment(grid = FALSE, base_size = 12, axis_title_size = 14, bg_col = "transparent") +
  coord_cartesian() +
  theme(
    legend.position = "bottom",
    legend.direction = "horizontal",
    legend.box = "vertical",
    legend.text = element_text(size = 12),
    axis.text = element_text(colour = "black"),
    axis.text.x = element_blank(),
    strip.text.y.left = element_text(angle = 0, hjust = 1),
    panel.spacing.y = unit(0, "lines")
  ) +
  #facet_wrap(~ reorder(comp_new, -abs(rg)), scales = "free", strip.position = "left", ncol = 1)
  facet_wrap(~ comp_new, scales = "free", strip.position = "left", ncol = 1)
ggsave("figures/LDSC_stats_matrix_DIAG.png", p, width = 11, height = 13, dpi = 600, bg = "white")

saveRDS(p, file = "files/LDSC_stats_matrix_DIAG.rds")



