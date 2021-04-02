### PLOT QUESTION SCORES DISTRIBUTION ########################

#-- Libraries -------------------------

library(tidyverse)
library(normentR)

#-- Load data ------------------------

qdata <- read_csv("files/normed_data_resid_HCwPSY_export.txt")

question_defs <- read_delim("files/Question_defs.txt", delim = "\t") %>%
  mutate(fieldid = paste0("v",fieldid,".0.0_resid"))

#-- Prepare data ------------------------

qdata_long <- qdata %>%
  pivot_longer(cols = starts_with("v20"), names_to = "fieldid", values_to = "score") %>%
  inner_join(question_defs, by = "fieldid")

qdata_long_comb <- qdata_long %>%
  mutate(group = "HC + PSY")

plotdata <- qdata_long %>%
  mutate(group = as_factor(group))

nHC <- qdata %>%
  filter(group == "HC") %>%
  nrow(.)
nPSY <- qdata %>%
  filter(group == "PSY") %>%
  nrow(.)

#-- Create plot ------------------------

col_palette <- c("grey30",norment_colors[["purple"]])
labels <- c("No diagnosis (N = 136 678)","Psychiatric diagnosis (N = 9082)")

plot <- ggplot(plotdata, aes(x = score, fill = group)) +
  geom_vline(xintercept = 0, color = "grey80", linetype = "dashed") +
  geom_density(alpha = 0.5, color = "transparent") +
  labs(x = "Score (z-score normalized and residualized)",
       y = "Density",
       fill = NULL) +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_fill_manual(values = col_palette, 
                    labels = labels) +
  theme_norment(grid = FALSE, axis = TRUE, base_size = 12) +
  theme(
    axis.title.x = element_text(size = 24),
    axis.title.y = element_text(size = 24),
    legend.text = element_text(size = 18),
    strip.text = element_text(size = 10)
  ) +
  facet_wrap(~ question_new, labeller = label_wrap_gen(width = 45),
             scales = "free", ncol = 5)

ggsave("figures/QuestionScores_distribution_both.png", plot, width = 20, height = 25)



