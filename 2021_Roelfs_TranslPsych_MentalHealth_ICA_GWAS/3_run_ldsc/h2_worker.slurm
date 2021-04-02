#!/bin/sh

#SBATCH --job-name=h2_worker
#SBATCH --account=p33_norment_dev
#SBATCH --time=00:15:00
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=8GB
#SBATCH --cpus-per-task=1

module load python2.gnu/2.7.15

echo "Submitted from ${SUBMITDIR}"
echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"

OUTDIR="${SUBMITDIR}/ldsc_out"

SUMSTATDIR="/sumstats"
RESOURCEDIR="/resources"
LDSCDIR="/software/python/ldsc"

cd $SCRATCH

# Run LDSC
python2 ${LDSCDIR}/ldsc.py \
    --h2 ${SUMSTATDIR}/GWAS_IC${SLURM_ARRAY_TASK_ID}_munged.sumstats.gz \
    --ref-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
    --w-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
    --out h2_IC${SLURM_ARRAY_TASK_ID}

rsync -a h2_IC${SLURM_ARRAY_TASK_ID}.log ${OUTDIR}/

