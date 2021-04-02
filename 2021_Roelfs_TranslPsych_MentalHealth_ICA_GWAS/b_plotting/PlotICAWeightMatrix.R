### CREATE ICA WEIGHT FIGURE ########################

#-- Libraries -------------------------

library(tidyverse)
library(normentR)

#-- Load data -------------------------

load("files/ica_dat.RData")
load("files/pc_dat.RData")

ic_defs <- read_delim("files/IC_names.txt", delim = "\t") %>%
  mutate(comp_label = str_glue("{component} ({comp_def})"))

#-- Get questionnaires -------------------------

questions <- read_csv("files/UKBquestionnaires_mentalhealth.csv") %>%
  mutate(field = paste0("v",fieldid,".0.0_resid")) %>%
  inner_join(read_delim("files/Question_defs.txt", delim = "\t"))

#-- Prepare data -------------------------

wmatrix <- data.frame(t(ica_dat$A))
names(wmatrix) <- sprintf("IC%s",seq(ncol(wmatrix)))

wmatrix_long <- wmatrix %>%
  mutate(field = rownames(pc_dat$rotation)) %>%
  gather(key = "IC", value = "loading", -field)

longdata <- merge(wmatrix_long, questions, by = "field") %>%
  group_by(fieldid) %>%
  mutate(n = cur_group_id())

nICs <- length(unique(wmatrix_long$IC))

#-- Reorder questions based on hclust -------------------------

dmatrix <- dist(as.matrix(wmatrix))
clust <- hclust(dmatrix)
order <- clust$order

#-- Final preparations -------------------------

plotdata <- longdata %>%
  right_join(ic_defs, by = c("IC" = "component")) %>%
  mutate(loading_inv = loading * trans)

#-- Create plot -------------------------

p <- ggplot(plotdata, aes(x = reorder(comp_label,parse_number(comp_label)), 
                          y = question_new, fill = loading_inv)) +
  geom_tile(color = "transparent") + 
  labs(x = NULL,
       y = NULL,
       fill = NULL) +
  #scale_y_discrete(breaks = c(1,seq(10,30,10),max(plotdat$n))) +
  #scale_x_discrete(limits = sprintf("IC%s",1:nICs)) +
  scale_fill_norment(discrete = FALSE, palette = "berlin", limits = c(-1.02,1.02),
                     guide = guide_colorbar(nbin = 100, barwidth = 0.75, barheight = 24, ticks = FALSE)) +
  theme_norment(grid = FALSE) +
  theme(
    legend.position = "right",
    legend.text = element_text(size = 8),
    axis.text.y = element_text(size = 9),
    axis.text.x = element_text(size = 9, angle = 35, hjust = 1),
    axis.title.x = element_text(size = 14)
  )
p

ggsave("figures/ICAWeightMatrix.png", width = 300, height = 200, units = "mm")

