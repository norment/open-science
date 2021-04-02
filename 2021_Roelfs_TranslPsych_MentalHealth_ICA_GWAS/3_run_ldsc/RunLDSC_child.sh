#!/bin/bash

module load python2.gnu/2.7.16

echo "Running from ${PWD}"

DIAG=`basename $1 | awk -F . '{print $1}' | awk -F _ '{print $1 "_" $2 "_" $3}'`
DIAGFILE="${DIAG}_munged.sumstats.gz"

COMP=`basename $2 | awk -F _ '{print $2}'`

SUMSTATDIR="/sumstats"
RESOURCEDIR="/resources"
LDSCDIR="/software/python/ldsc"

echo "Running comparison between ${COMP} and ${DIAG}"

# Run LDSC
python2 ${LDSCDIR}/ldsc.py \
    --rg ${SUMSTATDIR}/${DIAGFILE},${2} \
    --ref-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
    --w-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
    --out ldsc_${DIAG}_by_${COMP}

