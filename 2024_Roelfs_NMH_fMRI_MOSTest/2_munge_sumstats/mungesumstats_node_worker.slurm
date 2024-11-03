#!/bin/bash

#SBATCH --job-name=mungesumstats_node_worker
#SBATCH --time=00:30:00

module load python2.gnu/2.7.16

echo "Submitted from ${SUBMITDIR}"
echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"

INDIR="${PROJECTDIR}/mostest/mostest_out"
OUTDIR="${SUBMITDIR}/sumstats_node"
PYCONVDIR="${SOFTWAREDIR}/python_convert"
LDSCDIR="${SOFTWAREDIR}/ldsc"
RESOURCEDIR="resources"

cd $SCRATCH

echo "Copying in files"
cp ${INDIR}/node_mostest.node${SLURM_ARRAY_TASK_ID}_resid.orig.sumstats.gz file_in.sumstats.gz

echo "Start conversion"
# Prepare node data
python2 ${PYCONVDIR}/sumstats.py csv \
    --sumstats file_in.sumstats.gz \
    --out node_${SLURM_ARRAY_TASK_ID}.STD \
    --force --auto --head 5
python2 ${PYCONVDIR}/sumstats.py qc \
    --sumstats node_${SLURM_ARRAY_TASK_ID}.STD \
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
    --out node_${SLURM_ARRAY_TASK_ID}_munged

#rsync -a node_${SLURM_ARRAY_TASK_ID}_munged.log ${OUTDIR}/
rsync -a ToMunge.sumstats.gz ${OUTDIR}/node_${SLURM_ARRAY_TASK_ID}.sumstats.gz
rsync -a node_${SLURM_ARRAY_TASK_ID}_munged.sumstats.gz ${OUTDIR}/

