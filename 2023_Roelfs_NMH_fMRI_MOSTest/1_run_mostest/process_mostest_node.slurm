#!/bin/bash

#SBATCH --job-name=processmostest_node_worker
#SBATCH --time=04:00:00

module load python2.gnu/2.7.16

echo "Submitted from ${SUBMITDIR}"

cd ${SUBMITDIR}

OUTDIR="${SUBMITDIR}/mostest_out/node_mostest"
PROCESSSCRIPT="${SOFTWAREDIR}/mostest/process_results.py"
PROCESSSCRIPTUNI="${SOFTWAREDIR}/mostest/process_results_ext.py"
BIMFILE="${SUBMITDIR}/UKB42k_QCed_160320_MOSTest_sorted_node.bim"

echo "Processing MOSTest files"

#python ${PROCESSSCRIPT} ${BIMFILE} ${OUTDIR}
python ${PROCESSSCRIPTUNI} ${BIMFILE} ${OUTDIR}

echo "Done"

