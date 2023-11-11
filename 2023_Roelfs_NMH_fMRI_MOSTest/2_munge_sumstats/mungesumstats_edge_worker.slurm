#!/bin/bash

#SBATCH --job-name=mungesumstats_edge_worker
#SBATCH --time=00:30:00

module load python2.gnu/2.7.16

echo "Submitted from ${SUBMITDIR}"
echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"

INDIR="${PROJECTDIR}/mostest/mostest_out"
OUTDIR="${SUBMITDIR}/sumstats_edge"
PYCONVDIR="${SOFTWAREDIR}/python/python_convert"
LDSCDIR="${SOFTWAREDIR}/python/ldsc"
RESOURCEDIR="resources"

cd $SCRATCH

echo "Copying in files"
cp ${INDIR}/edge_mostest.edge${SLURM_ARRAY_TASK_ID}_resid.orig.sumstats.gz file_in.sumstats.gz

echo "Start conversion"
# Prepare edge data
python2 ${PYCONVDIR}/sumstats.py csv \
    --sumstats file_in.sumstats.gz \
    --out edge_${SLURM_ARRAY_TASK_ID}.STD \
    --force --auto --head 5
python2 ${PYCONVDIR}/sumstats.py qc \
    --sumstats edge_${SLURM_ARRAY_TASK_ID}.STD \
    --out ToMunge.sumstats \
    --exclude-ranges 6:26000000:34000000 \
    --force

head ToMunge.sumstats
wc -l ToMunge.sumstats
gzip ToMunge.sumstats

python2 ${LDSCDIR}/munge_sumstats.py \
    --sumstats ToMunge.sumstats.gz \
    --merge-alleles ${RESOURCEDIR}/w_hm3.noMHC.snplist \
    --ignore BETA \
    --out edge_${SLURM_ARRAY_TASK_ID}_munged

#rsync -a edge_${SLURM_ARRAY_TASK_ID}_munged.log ${OUTDIR}/
rsync -a ToMunge.sumstats.gz ${OUTDIR}/edge_${SLURM_ARRAY_TASK_ID}.sumstats.gz
rsync -a edge_${SLURM_ARRAY_TASK_ID}_munged.sumstats.gz ${OUTDIR}/

