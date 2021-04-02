#!/bin/bash

#SBATCH --job-name=LDSC_DIAGxDIAG_worker
#SBATCH --account=p33_norment_dev
#SBATCH --time=00:15:00
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=8GB
#SBATCH --cpus-per-task=1

module load python2.gnu/2.7.15

echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"
echo "Running from ${SUBMITDIR}"

SUMSTATDIR="/sumstats"
GWASLIST="${SUBMITDIR}/files/GWAS_LDSC.txt"
RESOURCEDIR="/resources"
LDSCDIR="/software/python/ldsc"

OUTDIR="${SUBMITDIR}/ldsc_out"

cd ${SCRATCH}

D1=`sed -n -e ${SLURM_ARRAY_TASK_ID}p ${GWASLIST}`
DIAG1=`basename $D1 | awk -F . '{print $1}' | awk -F _ '{print $1 "_" $2 "_" $3}'`
DIAG1FILE="${DIAG1}_munged.sumstats.gz"

s=$((${SLURM_ARRAY_TASK_ID} + 1))

for n in `seq ${s} 9`; do

	D2=`sed -n -e ${n}p ${GWASLIST}`
	DIAG2=`basename $D2 | awk -F . '{print $1}' | awk -F _ '{print $1 "_" $2 "_" $3}'`
	DIAG2FILE="${DIAG2}_munged.sumstats.gz"

	echo "Running LDSC between ${DIAG1} and ${DIAG2}"

	# Run LDSC with each other node
	python2 ${LDSCDIR}/ldsc.py \
	    --rg ${SUMSTATDIR}/${DIAG1FILE},${SUMSTATDIR}/${DIAG2FILE} \
	    --ref-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
	    --w-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
	    --out ldsc_DxD_${DIAG1}_by_${DIAG2}

done

rsync -a ldsc_*.log ${OUTDIR}/

