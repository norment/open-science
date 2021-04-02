### EXTRACT UKB QUESTIONNAIRE FIELDS ########################

#-- Libraries ------------------------

library(tidyverse)
library(officer)
library(flextable)

#-- Load data -------------------------

qoi_list <- read_csv("files/UKBquestionnaires_mentalhealth.csv") %>%
  mutate(col_name = paste0(fieldid,"-0.0"))

load("files/pc_dat.RData")

#-- Prepare data -------------------------

incl_fieldids <- parse_number(rownames(pc_dat$rotation))

data <- qoi_list %>%
  filter(fieldid %in% incl_fieldids) %>%
  mutate(no = row_number()) %>%
  select(no,question,coding)

#-- Create table -------------------------

# Create flextable object
ft <- flextable(data = data) %>% 
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
