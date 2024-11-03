#!/bin/bash

#SBATCH --job-name=h2_edge_worker
#SBATCH --time=00:15:00

module load python2.gnu/2.7.16

echo "Submitted from ${SUBMITDIR}"
echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"

OUTDIR="${SUBMITDIR}/ldsc_out_edge"

INDIR="${PROJECTDIR}/munge_sumstats/sumstats_edge"
RESOURCEDIR="resources"
LDSCDIR="${SOFTWAREDIR}/ldsc"

cd $SCRATCH

# Run LDSC
python2 ${LDSCDIR}/ldsc.py \
    --h2 ${INDIR}/edge_${SLURM_ARRAY_TASK_ID}_munged.sumstats.gz \
    --ref-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
    --w-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
    --out h2_edge_${SLURM_ARRAY_TASK_ID}

rsync -a h2_edge_${SLURM_ARRAY_TASK_ID}.log ${OUTDIR}/

