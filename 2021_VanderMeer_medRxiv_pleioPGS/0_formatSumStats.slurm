#!/bin/bash

#SBATCH --job-name=FormatSumstats
#SBATCH --account=p33_norment
#SBATCH --time=4:00:00
#SBATCH --mem-per-cpu=12G

module purge 
set -o errexit

module load python2.gnu/2.7.15

HOME=/cluster/projects/p33/users/dennisva
PYDIR=${HOME}/Software/python_convert-master
LDDIR=${HOME}/Software/ldsc-master
WD=${HOME}/PleioSZ/Sumstats
Version=PGC3
Sumstats=PGC_SCZ_0518_EUR_noTOP

## Standardize col names etc.
python2 ${PYDIR}/sumstats.py csv --sumstats ${WD}/${Sumstats}.sumstats.gz --out ${WD}/${Sumstats}.STD --force --auto --head 5
## Remove MHC
python2 ${PYDIR}/sumstats.py qc --sumstats ${WD}/${Sumstats}.STD --out ${WD}/${Sumstats}.STD.noMHC --exclude-ranges 6:26000000-34000000 --force
## Add Z-score
python2 ${PYDIR}/sumstats.py zscore --sumstats ${WD}/${Sumstats}.STD.noMHC --out ${WD}/${Sumstats}.STD.noMHC.Z --force
## Format for LDSR and UGMG
python2 ${LDDIR}/munge_sumstats.py --sumstats ${WD}/${Sumstats}.STD.noMHC.Z --merge-alleles ${LDDIR}/eur_w_ld_chr/w_hm3.snplist --ignore BETA --out ${WD}/${Sumstats}.STD.noMHC.Z.LDSR
## Make mat for FDR
python2 ${PYDIR}/sumstats.py mat --sumstats ${WD}/${Sumstats}.STD.noMHC.Z --out ${WD}/${Sumstats}.mat --force --ref ${HOME}/Software/pleiofdr/9545380.ref


