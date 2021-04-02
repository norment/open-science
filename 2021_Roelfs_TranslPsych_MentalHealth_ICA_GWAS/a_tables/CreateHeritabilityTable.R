### CREATE HERITABILITY RESULTS TABLE ########################

#-- Libraries -------------------------

library(tidyverse)
library(officer)
library(flextable)

#-- Load data ------------------------

h2_load <- read.table("files/LDSC_h2.txt", header = TRUE) %>%
  mutate(component = paste0(calc,component))

ic_defs <- read_delim("files/IC_names.txt", delim = "\t") %>%
  mutate(comp_label = str_glue("{component} ({comp_def})"))

#-- Prepare data ------------------------

h2 <- h2_load %>%
  inner_join(ic_defs) %>%
  mutate(h2_se = str_glue("{h2} ({se})"),
         int_se = str_glue("{intercept} ({intercept_se})"),
         LambdaGC = format(LambdaGC))

h2_table <- h2 %>%
  arrange(parse_number(comp_label)) %>%
  select(
    IC = component,
    `Component represents` = comp_def,
    `h2 (SE)` = h2_se,
    `Lambda GC` = LambdaGC,
    `Intercept (SE)` = int_se
  )

#-- Create table -------------------------

# Create flextable object
ft <- flextable(data = h2_table) %>% 
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
