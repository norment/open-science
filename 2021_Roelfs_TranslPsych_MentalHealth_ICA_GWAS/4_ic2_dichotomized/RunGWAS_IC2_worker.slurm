#!/bin/sh

#SBATCH --job-name=RunGWAS_IC2_worker
#SBATCH --account=p33
#SBATCH --time=48:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=16GB
#SBATCH --cpus-per-task=1

module load plink2/2.00a2LM

echo "Submitted from ${SUBMITDIR}"
echo "Running GWAS for dichotomized IC2"

BFILE="/ukbio/genetics/UKB500k_300120/UKB500k_QCed_300120"
PHENOFILE="/files/IC2_dich.csv"
OUTDIR="${SUBMITDIR}/gwas_out"

# cd to job directory
cd $SCRATCH

# Run GWAS
plink2 --bfile ${BFILE} --logistic --threads 1 --pheno ${PHENOFILE} --pheno-name IC2_dich --out GWAS

# Copy data back
rsync -a GWAS* $OUTDIR/


