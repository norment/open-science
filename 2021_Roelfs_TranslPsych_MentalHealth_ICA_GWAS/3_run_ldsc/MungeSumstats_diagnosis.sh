#!/bin/bash

module load python2.gnu/2.7.15

file=$1

OUTDIR="/sumstats"
SUMSTATDIR="/sumstats/raw"
RESOURCEDIR="/resources"
LDSCDIR="/software/python/ldsc"

# Get diagnosis
DIAG=`echo $file | awk -F . '{print $1}' |awk -F _ '{print $1 "_" $2 "_" $3}'`

python2 ${LDSCDIR}/munge_sumstats.py \
    --sumstats ${SUMSTATDIR}/${file} \
    --merge-alleles ${RESOURCEDIR}/w_hm3.noMHC.snplist \
		--ignore OR,SE,VARIANT_ID,BETA \
		--N-cas-col NCASE \
		--N-con-col NCONTROL \
    --out ${OUTDIR}/${DIAG}_munged

