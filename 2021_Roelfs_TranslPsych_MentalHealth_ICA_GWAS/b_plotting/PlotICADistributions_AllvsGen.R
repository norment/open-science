### PLOT ICA LOADINGS DISTRIBUTION ########################

#-- Libraries -------------------------

library(tidyverse)
library(normentR)

#-- Functions -------------------------

GeomSplitViolin <- ggproto("GeomSplitViolin", GeomViolin, 
                           draw_group = function(self, data, ..., draw_quantiles = NULL) {
                             data <- transform(data, xminv = x - violinwidth * (x - xmin), xmaxv = x + violinwidth * (xmax - x))
                             grp <- data[1, "group"]
                             newdata <- plyr::arrange(transform(data, x = if (grp %% 2 == 1) xminv else xmaxv), if (grp %% 2 == 1) y else -y)
                             newdata <- rbind(newdata[1, ], newdata, newdata[nrow(newdata), ], newdata[1, ])
                             newdata[c(1, nrow(newdata) - 1, nrow(newdata)), "x"] <- round(newdata[1, "x"])
                             
                             if (length(draw_quantiles) > 0 & !scales::zero_range(range(data$y))) {
                               stopifnot(all(draw_quantiles >= 0), all(draw_quantiles <=
                                                                         1))
                               quantiles <- ggplot2:::create_quantile_segment_frame(data, draw_quantiles)
                               aesthetics <- data[rep(1, nrow(quantiles)), setdiff(names(data), c("x", "y")), drop = FALSE]
                               aesthetics$alpha <- rep(1, nrow(quantiles))
                               both <- cbind(quantiles, aesthetics)
                               quantile_grob <- GeomPath$draw_panel(both, ...)
                               ggplot2:::ggname("geom_split_violin", grid::grobTree(GeomPolygon$draw_panel(newdata, ...), quantile_grob))
                             }
                             else {
                               ggplot2:::ggname("geom_split_violin", GeomPolygon$draw_panel(newdata, ...))
                             }
                           })

geom_split_violin <- function(mapping = NULL, data = NULL, stat = "ydensity", position = "identity", ..., 
                              draw_quantiles = NULL, trim = TRUE, scale = "area", na.rm = FALSE, 
                              show.legend = NA, inherit.aes = TRUE) {
  layer(data = data, mapping = mapping, stat = stat, geom = GeomSplitViolin, 
        position = position, show.legend = show.legend, inherit.aes = inherit.aes, 
        params = list(trim = trim, scale = scale, draw_quantiles = draw_quantiles, na.rm = na.rm, ...))
}

#-- Load data -------------------------

load("files/ica_dat.RData")
loadings_all <- data.frame(ica_dat$S)
names(loadings_all) <- sprintf("IC%s",seq(ncol(loadings_all)))

loadings_gen <- read_csv("files/ica_loadings_plink.txt") %>%
  select(-IID,-FID)

ic_defs <- read_delim("files/IC_names.txt", delim = "\t") %>%
  mutate(comp_label = str_glue("{component} ({comp_def})"))

#-- Prepare data ------------------------

loadings_all_long <- loadings_all %>%
  pivot_longer(starts_with("IC"), names_to = "component", values_to = "loading") %>%
  merge(ic_defs, by = "component")

plotdata_all <- loadings_all_long %>%
  mutate(sample = "All loadings (n = 136 678)",
         comp_label = fct_reorder(comp_label, parse_number(comp_label)),
         loading_inv = loading * trans)

loadings_gen_long <- loadings_gen %>%
  pivot_longer(starts_with("IC"), names_to = "component", values_to = "loading") %>%
  mutate(component = str_extract(component, "[^_]+")) %>%
  merge(ic_defs, by = "component")

plotdata_gen <- loadings_gen_long %>%
  mutate(sample = "Loadings for GWAS (n = 117 611)",
         comp_label = fct_reorder(comp_label, parse_number(comp_label)),
         loading_inv = loading * trans)

plotdata <- rbind(plotdata_all,plotdata_gen)

all_col <- rgb(60,145,154, maxColorValue = 255)
gen_col <- rgb(228,71,40, maxColorValue = 255)

#-- Create plot -------------------------

ggplot(plotdata, aes(x = 1, y = loading_inv, color = sample, fill = sample)) +
  geom_hline(yintercept = 0, color = "grey60") + 
  geom_split_violin() +
  labs(x = NULL,
       y = "IC Loading",
       fill = NULL, 
       color = NULL) +
  scale_x_continuous(labels = NULL) + 
  #scale_color_manual(breaks = c("Female","Male"), values = c("Male" = mcol, "Female" = fcol)) +
  #scale_fill_manual(breaks = c("Female","Male"), values = c("Male" = mcol, "Female" = fcol)) +
  scale_color_manual(values = c(all_col,gen_col)) +
  scale_fill_manual(values = c(all_col,gen_col)) +
  theme_norment(base_size = 12, axis_title_size = 14, strip_text_size = 13) +
  theme(
    strip.text = element_text(size = 8),
    legend.position = "top",
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  ) +
  facet_wrap(~ comp_label, nrow = 4, scales = "free")
ggsave("figures/IC_loadings_distributions_sample.png", width = 26, height = 30, units = "cm")

