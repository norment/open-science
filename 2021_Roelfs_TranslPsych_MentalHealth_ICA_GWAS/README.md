# Scripts and summary statistics for Roelfs _et al._'s ICA genetics paper

### Corresponding paper
Roelfs et al., _Phenotypically independent profiles relevant to mental health are genetically correlated_, Translational Psychiatry, 2021, doi: [10.1038/s41398-021-01313-x](https://doi.org/10.1038/s41398-021-01313-x)

### Summary statistics for the independent components

GWAS summary statistics are located in the `sumstats` folder. There's two versions of every GWAS summary statistics file, one with the raw output from PLINK (~ 12 million SNPs), and one munged file used for LD Score regression.

### Scripts

The other folders contain scripts, in R or bash, that we used to residualize the z-normalized questionnaire data, perform the ICA, run the GWAS, and run LD Score regression. There's also a folder with the scripts we used to analyze the dichotomized IC2 (psychosis component). 

### Tables and Plots

Folders `a_tables` and `b_plotting` contain a variety of R scripts used to generate the tables and figures in both the main text and the supplemental material from the paper.