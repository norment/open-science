# Introduction
PleioPGS is an approach to predict a trait of interest by calculating polygenic scores based on genetic variants that have been identified by conditioning the genetics of that trait on the genetics of another trait. The idea is that leveraging the auxilliary information from the second trait boosts power and allows for the identification of more relevant variants, the subset that have an effect on both traits (interesting in terms of e.g. comorbidity). Additionally, this may weed out false positives in the original GWAS. The concept, and its application to schizophrenia conditioned on brain morphology, is described in: 
* Van der Meer et al. (2020). Improved prediction of schizophrenia by leveraging genetic overlap with brain morphology. MedRxiv. https://doi.org/10.1101/2020.08.03.20167510 

# Conceptual steps
PleioPGS consists of the following steps:
1) We select the GWAS summary statistics of a primary and secondary trait of interest and calculate for every genetic variant a test statistic that reflects the evidence for pleiotropic effects. In the initial study, we employed conditional false discovery rate analysis (cFDR) for this.
2) We clump the genetic variants based on the new test statistic and sort the resulting lead SNPs by significance. This was done with a basic Plink clump call.
3) We filter the GWAS summary statistic of the primary trait of interest to only retain the top lead SNPs and then calculate polygenic scores for a test sample based on this filtered summary statistic (omitting clumping). Polygenic scores were calculated through the PRSice software, although other tools may work as well.
!) step 2 and 3 may also be repeated by clumping the original GWAS summary statistics, for comparison, which comes down to 'regular' polygenic scoring.

# Practical details
Most tools used for running the analyses are part of the github.com/precimed collection of repositories. The analyses were run on 
Ubuntu 18.04.;
MATLAB (2017a);
Python (3.7);

The central scripts used for carrying out the analyses are provided in this repository, with the prefixes corresponding to the above steps. Note that, at the moment, these are not entirely stand-alone; they do depend on some helper files and require knowledge how to run cFDR (see the precimed repositories for instructions). In other words, these scripts are primarily provided to illustrate the concept of pleioPGS. 
