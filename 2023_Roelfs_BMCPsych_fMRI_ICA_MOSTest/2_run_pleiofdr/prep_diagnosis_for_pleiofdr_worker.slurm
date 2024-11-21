#!/bin/bash

#SBATCH --job-name=PrepForPleioFDR_diagnosis_worker
#SBATCH --time=00:20:00

module load python2.gnu/2.7.16

echo "Submitted from ${SUBMITDIR}"
echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"

INDIR="${SUBMITDIR}/sumstats/raw"
OUTDIR="${SUBMITDIR}/sumstats"
PYCONVDIR="${SOFTWAREDIR}/python_convert"
REFFILE="resources/9545380.ref"
GWASLIST="${SUBMITDIR}/GWAS_pleio.txt"

DIAGFILE=`sed -n -e ${SLURM_ARRAY_TASK_ID}p ${GWASLIST}`
DIAG=`basename $DIAGFILE | awk -F . '{print $1}'`

cd ${SCRATCH}

python ${PYCONVDIR}/sumstats.py csv --auto --sumstats ${INDIR}/${DIAGFILE} --out ${DIAG}.sumstats.csv --force
python ${PYCONVDIR}/sumstats.py mat --sumstats ${DIAG}.sumstats.csv --ref ${REFFILE} --out ${OUTDIR}/${DIAG}.sumstats.mat

