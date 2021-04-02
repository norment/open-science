#!/bin/sh

#SBATCH --job-name=RunLDSC_master_worker
#SBATCH --account=p33_norment_dev
#SBATCH --time=00:30:00
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=2GB
#SBATCH --cpus-per-task=1

echo "Submitted from ${SUBMITDIR}"
echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"

# Set directories
SUMSTATDIR="/sumstats"
GWASLIST="${SUBMITDIR}/files/GWAS_LDSC.txt"
OUTDIR="${SUBMITDIR}/ldsc_out"

# Copy files
cp ${SUBMITDIR}/RunLDSC_child.sh ${SCRATCH}

DIAG=`sed -n -e ${SLURM_ARRAY_TASK_ID}p ${GWASLIST}`

cd $SCRATCH

echo "Running LDSC for ${DIAG}"

for j in `seq 13`
do
	QGWAS="GWAS_IC${j}_munged.sumstats.gz"
	bash RunLDSC_child.sh ${SUMSTATDIR}/${DIAG} ${SUMSTATDIR}/${QGWAS}
done

rsync -a ldsc_*.log ${OUTDIR}/

