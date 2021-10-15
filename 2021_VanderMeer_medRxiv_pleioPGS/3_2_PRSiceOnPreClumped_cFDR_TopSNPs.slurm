#!/bin/bash

#SBATCH --job-name=PGRS
#SBATCH --account=p33
#SBATCH --time=2:00:00
#SBATCH --mem-per-cpu=12G

module purge 
module load plink
module load R/3.4.0

HOME=/cluster/projects/p33/users/dennisva/PleioSZ/PRS
cd /cluster/projects/p33/users/dennisva/Software/PRSice_linux

## select top n rows from sumstats
nrow=$((nsnps + 1))
head -n +${nrow} ${HOME}/SumStats/${trait}_CondFDRLeads4PRS_${Version}_sorted_${maf}.sumstats | awk 'NF{NF--};1' > ${HOME}/SumStats/${trait}_CondFDRLeads4PRS_${Version}_n${nsnps}_${maf}.sumstats

### PRS calc. TOP
Rscript PRSice.R --dir . --prsice ./PRSice \
--base ${HOME}/SumStats/${trait}_CondFDRLeads4PRS_${Version}_n${nsnps}_${maf}.sumstats --beta \
--target /cluster/projects/p33/users/dennisva/PleioSZ/Gen/NORMENT_QCed \
--A1 A1 --A2 A2 --bp BP --chr CHR --pvalue PVAL --stat ${statcol} --snp SNP \
--bar-levels 1 --fastscore --no-full --no-clump \
--no-regress --score std --out ${HOME}/${maf}/${Version}/PRS_${trait}_n${nsnps}_CondFDRTOP

