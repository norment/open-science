##### RESIDUALIZE NORMALIZED QUESTIONNAIRE DATA #########################

#-- Libraries -------------------------

library(tidyverse)

#-- Load data -------------------------

data <- read_csv("files/normed_data.csv")
load("../files/demogr.RData")

#-- Merge data -------------------------

all_data <- merge(data, demogr, by = "eid")

missing_gPC <- all_data[rowSums(is.na(all_data %>% select(starts_with("gPC")))), ]
paste0(sprintf("Number of individuals with missing genetic PCs: %s",nrow(missing_gPC)))

have_gPC <- all_data %>%
	drop_na()

to_regr <- have_gPC

#-- Loop through questions -------------------------

for (q_ind in which(str_detect(names(to_regr),"^v20"))) {

	qid <- names(to_regr)[q_ind]
  
  rdat <- lm(data = to_regr, to_regr[[q_ind]] ~ 
             poly(age,2) + 
             sex + 
             gPC1 + gPC2 + gPC3 + gPC4 + gPC5 + gPC6 + 
             gPC7 + gPC7 + gPC8 + gPC9 + gPC10 + gPC11 +
						 gPC12 + gPC13 + gPC14 + gPC15 + gPC16 + 
						 gPC17 + gPC18 + gPC19 + gPC20)
  
  to_regr[ ,paste0(qid,"_resid")] <- as.vector(rdat$residuals)

	rm(rdat)
  
}


#-- Prepare for saving -------------------------

to_write <- to_regr %>%
	select(eid, ends_with("_resid"))

#-- Write to file -------------------------

write_csv(to_write, "files/normed_data_resid.csv")

#-- Write file for MATLAB -------------------------

matdat <- to_write %>%
        select(-eid) %>%
	as.matrix()

R.matlab::writeMat("files/normed_data_resid.mat", matdat = matdat)








