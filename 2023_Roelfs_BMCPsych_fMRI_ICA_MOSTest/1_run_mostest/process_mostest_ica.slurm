#!/bin/bash

#SBATCH --job-name=processmostest_ica_worker
#SBATCH --time=72:00:00

module load python2.gnu/2.7.16

echo "Submitted from ${SUBMITDIR}"

cd ${SUBMITDIR}

OUTDIR="${SUBMITDIR}/mostest_out/ica_mostest"
PROCESSSCRIPT="${SOFTWAREDIR}/mostest/process_results.py"
BIMFILE="${SUBMITDIR}/UKB500k_300120/UKB500k_QCed_300120_sorted_ica.bim"

echo "Processing MOSTest files"

python ${PROCESSSCRIPT} ${BIMFILE} ${OUTDIR}

echo "Done"

