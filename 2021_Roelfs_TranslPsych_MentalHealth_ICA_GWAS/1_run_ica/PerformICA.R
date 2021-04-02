##### PERFORM INDEPENDENT COMPONENT ANALYSIS #########################

#-- Libraries -------------------------

library(tidyverse)
library(fastICA)

#-- Load data -------------------------

data <- read_csv("files/normed_data_resid.csv")

#-- Prepare data -------------------------

data_prep <- data %>%
	select(-eid) %>%
	as.matrix()

#-- Run ICA -------------------------

# NOTE: we ran the analysis with the following seed, but due to consistency with earlier versions, 
# we relabeled the components to maintain the same IC labels as in previous analyses that used
# a different subset of questions.
set.seed(2020)

ica_dat <- fastICA(data_prep, n.comp = 13, alg.typ = "parallel",
									 fun = "exp", alpha = 1, method = "C", 
									 maxit = 5000, verbose = TRUE)

save(ica_dat, file = "files/ica_dat.RData")

#-- Write to file -------------------------

ica_loadings <- data.frame(eid = data$eid, IC = ica_dat$S)
names(ica_loadings) <- str_replace(names(ica_loadings), "\\.", "")

write_csv(ica_loadings, "files/ica_loadings.csv")

#-- Visualize ICA -------------------------

par(mfrow = c(1, 3))
plot(ica_dat$X, main = "Pre-processed data")
plot(ica_dat$X %*% ica_dat$K, main = "PCA components")
plot(ica_dat$S, main = "ICA components")

