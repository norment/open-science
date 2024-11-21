#!/bin/bash

#SBATCH --job-name=mostest_ica_worker
#SBATCH --time=12:00:00

module load matlab/R2017a

cd ${SUBMITDIR}

# Run all
pheno="${SUBMITDIR}/ica_residualised_loadings.txt"
bfile="${SUBMITDIR}/UKB500k_300120/UKB500k_QCed_300120_sorted"
out="${SUBMITDIR}/mostest_out/ica_mostest"
nsubj=`cat ${bfile}.fam | wc -l`
nsnps=`cat ${bfile}.bim | wc -l`

matlab -nodesktop -nosplash -r "runMOSTest('${pheno}', '${bfile}', '${out}', ${nsnps}, ${nsubj});exit"

# Run from z-score transformation
zmat="${PROJECTDIR}/mostest/mostest_out/ica_mostest_zmat.mat"
out="${SUBMITDIR}/mostest_out/ica_mostest"

matlab -nodesktop -nosplash -r "runMOSTest_zmat('${zmat}', '${out}');exit"

