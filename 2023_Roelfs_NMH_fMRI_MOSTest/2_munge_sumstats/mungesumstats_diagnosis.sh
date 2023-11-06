#!/bin/bash

module load python2.gnu/2.7.16

file="${1}"

OUTDIR="sumstats_dx/"
RESOURCEDIR="resources"
LDSCDIR="${SOFTWAREDIR}/ldsc"

# Get diagnosis
DIAG=`basename $file | awk -F . '{print $1}' | awk -F _ '{print $1 "_" $2 "_" $3}'`

python2 ${LDSCDIR}/munge_sumstats.py \
    --sumstats ${file} \
    --merge-alleles ${RESOURCEDIR}/w_hm3.noMHC.snplist \
		--ignore OR,SE,VARIANT_ID,BETA \
		--N-cas-col NCASE \
		--N-con-col NCONTROL \
    --out ${OUTDIR}/${DIAG}_munged

