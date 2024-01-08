#!/bin/bash

#SBATCH --job-name=h2_edge_worker
#SBATCH --time=00:15:00

module load python2.gnu/2.7.16

echo "Submitted from ${SUBMITDIR}"
echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"

OUTDIR="${SUBMITDIR}/ldsc_out_dx"

LISTDX="${PROJECTDIR}/ldsc/GWAS_LDSC.txt"
INDIR="${PROJECTDIR}/munge_sumstats/sumstats_dx"
RESOURCEDIR="resources"
LDSCDIR="${SOFTWAREDIR}/ldsc"

cd $SCRATCH

DXPRE=`cat ${LISTDX} | sed -n -e ${SLURM_ARRAY_TASK_ID}p | awk -F . '{print $1}' | awk -F _ '{print $1 "_" $2 "_" $3}'`
DXFILE="${DXPRE}_munged.sumstats.gz"

# Run LDSC
python2 ${LDSCDIR}/ldsc.py \
	--h2 ${INDIR}/${DXFILE} \
	--ref-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
	--w-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
	--out h2_${DXPRE}

rsync -a h2_${DXPRE}.log ${OUTDIR}/

