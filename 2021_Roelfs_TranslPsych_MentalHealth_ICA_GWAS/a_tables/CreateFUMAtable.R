### CREATE FUMA RESULTS TABLE ########################

#-- Libraries -------------------------

library(tidyverse)
library(officer)
library(flextable)

#-- Load data ------------------------

fuma_dirs <- list.files(pattern = "FUMA_job784*", full.names = TRUE)

fuma_load <- c()
for (i in seq(length(fuma_dirs))) {
  temp <- read_delim(paste0(fuma_dirs[i],"/genes.txt"), delim = "\t") %>%
    mutate(job = parse_number(fuma_dirs[i]))
  fuma_load <- rbind(fuma_load,temp)
  rm(temp)
}

fuma_names <- read_delim("files/FUMA_job_names.txt", delim = "\t")
ic_defs <- read_delim("files/IC_names.txt", delim = "\t") %>%
  mutate(comp_label = str_glue("{component} ({comp_def})"))

fuma <- fuma_load %>%
  inner_join(fuma_names) %>%
  inner_join(ic_defs)

#-- Prepare data ------------------------

fuma_summ <- fuma %>%
  group_by(comp_label) %>%
  summarise(n = n()) %>%
  arrange(-n)

fuma_table <- fuma %>%
  arrange(parse_number(comp_label)) %>%
  group_by(comp_label) %>%
  mutate(no = row_number(),
         IC_new = parse_number(comp_label)) %>%
  select(
    IC = IC_new,
    `Component represents` = comp_def,
    no = no, 
    Gene = symbol,
    Chr = chr,
    pmin = minGwasP,
    `Individual Significant SNP` = IndSigSNPs
  ) %>%
  mutate(IC = paste0("IC",IC)) %>%
  ungroup() %>%
  select(-comp_label)

#-- Create table -------------------------

# Create flextable object
ft <- flextable(data = fuma_table) %>% 
  theme_box() %>% 
  autofit()
# See flextable in RStudio viewer
ft

# Create a temp file
tmp <- tempfile(fileext = ".docx")

# Create a docx file
read_docx() %>% 
  body_add_flextable(ft) %>% 
  print(target = tmp)

# open word document
browseURL(tmp)
