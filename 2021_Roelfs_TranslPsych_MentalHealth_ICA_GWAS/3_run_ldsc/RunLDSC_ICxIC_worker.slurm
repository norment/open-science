#!/bin/bash

#SBATCH --job-name=LDSC_ICxIC_worker
#SBATCH --account=p33_norment_dev
#SBATCH --time=00:15:00
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=8GB
#SBATCH --cpus-per-task=1

module load python2.gnu/2.7.15

echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"
echo "Running from ${SUBMITDIR}"

SUMSTATDIR="/sumstats"
RESOURCEDIR="/resources"
LDSCDIR="/software/python/ldsc"

OUTDIR="${SUBMITDIR}/ldsc_out"

cd ${SCRATCH}

s=$((${SLURM_ARRAY_TASK_ID} + 1))

for n in `seq ${s} 13`; do

	echo "Running LDSC between IC${SLURM_ARRAY_TASK_ID} and IC${n}"
	
	# Run LDSC with each other node
	python2 ${LDSCDIR}/ldsc.py \
	    --rg ${SUMSTATDIR}/GWAS_IC${SLURM_ARRAY_TASK_ID}_munged.sumstats.gz,${SUMSTATDIR}/GWAS_IC${n}_munged.sumstats.gz \
	    --ref-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
	    --w-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
	    --out ldsc_IC${SLURM_ARRAY_TASK_ID}_by_IC${n}

done

rsync -a ldsc_IC${SLURM_ARRAY_TASK_ID}_by_IC*.log ${OUTDIR}/

