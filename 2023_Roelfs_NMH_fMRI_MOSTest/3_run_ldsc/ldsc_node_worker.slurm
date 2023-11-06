#!/bin/bash

#SBATCH --job-name=ldsc_node_worker
#SBATCH --time=00:15:00

module load python2.gnu/2.7.16

echo "Submitted from ${SUBMITDIR}"
echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"

# Define directories and files
OUTDIR="${SUBMITDIR}/ldsc_out_node"

LISTDX="${PROJECTDIR}/ldsc/GWAS_LDSC.txt"
INDIR="${PROJECTDIR}/munge_sumstats/sumstats_node"
DXDIR="${PROJECTDIR}/munge_sumstats/sumstats_dx"
RESOURCEDIR="resources"
LDSCDIR="${SOFTWAREDIR}/ldsc"

ndx=`cat ${SUBMITDIR}/GWAS_LDSC.txt | wc -l`

cd $SCRATCH

# Run LDSC
for i in `seq ${ndx}`; do

	DXPRE=`cat ${LISTDX} | sed -n -e ${i}p | awk -F . '{print $1}' | awk -F _ '{print $1 "_" $2 "_" $3}'`
	DXFILE="${DXPRE}_munged.sumstats.gz"

	python2 ${LDSCDIR}/ldsc.py \
    --rg ${INDIR}/node_${SLURM_ARRAY_TASK_ID}_munged.sumstats.gz,${DXDIR}/${DXFILE} \
    --ref-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
    --w-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
    --out ldsc_${DXPRE}_by_node${SLURM_ARRAY_TASK_ID}

done

rsync -a ldsc_*_by_node${SLURM_ARRAY_TASK_ID}.log ${OUTDIR}/

