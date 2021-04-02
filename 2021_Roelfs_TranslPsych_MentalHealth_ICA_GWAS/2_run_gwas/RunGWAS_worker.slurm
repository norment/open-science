#!/bin/bash

#SBATCH --job-name=RunGWAS_worker
#SBATCH --account=p33_norment
#SBATCH --time=16:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=16GB
#SBATCH --cpus-per-task=1

module load plink2/2.00a2LM

echo "Submitted from ${SUBMITDIR}"
echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"

BFILE="/ukbio/genetics/UKB500k_300120/UKB500k_QCed_300120"
PHENOFILE="/files/ica_loadings_plink.csv"
OUTDIR="${SUBMITDIR}/gwas_out"

# cd to job directory
cd $SCRATCH

# Run GWAS
plink2 --bfile ${BFILE} -glm --pheno ${PHENOFILE} --pheno-name IC${SLURM_ARRAY_TASK_ID} --out GWAS_IC${SLURM_ARRAY_TASK_ID}

# Copy data back
rsync -a GWAS_* $OUTDIR/

