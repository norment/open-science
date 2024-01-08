#!/bin/bash

#SBATCH --job-name=mostest_edge_worker
#SBATCH --time=12:00:00

module load matlab/R2017a

cd ${SUBMITDIR}

# Run all
pheno="${PROJECTDIR}/residualise_data/edge_residualised.txt"
bfile="${SUBMITDIR}/UKB42k_QCed_160320_MOSTest_sorted_edge"
out="${SUBMITDIR}/mostest_out/edge_mostest"
nsubj=`cat ${bfile}.fam | wc -l`
nsnps=`cat ${bfile}.bim | wc -l`

matlab -nodesktop -nosplash -r "runMOSTest('${pheno}', '${bfile}', '${out}', ${nsnps}, ${nsubj});exit"

# Run from z-score transformation
zmat="${PROJECTDIR}/mostest/mostest_out/edge_mostest_zmat.mat"
out="${SUBMITDIR}/mostest_out/edge_mostest"

matlab -nodesktop -nosplash -r "runMOSTest_zmat('${zmat}', '${out}');exit"

