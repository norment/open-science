#!/bin/bash

#SBATCH --job-name=uni_node_clump_worker
#SBATCH --time=00:20:00

echo "Submitted from ${SUBMITDIR}"
echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"

cd $SUBMITDIR

INFILE="../mostest/mostest_out/node_mostest.node${SLURM_ARRAY_TASK_ID}_resid.orig.sumstats.gz"

gwas=`basename $INFILE | awk -F . '{print $2}' | awk -F _ '{print $1}'`
outname="univariate/clumped_${gwas}_univariate"

bash clump_sumstats.sh $INFILE $outname

