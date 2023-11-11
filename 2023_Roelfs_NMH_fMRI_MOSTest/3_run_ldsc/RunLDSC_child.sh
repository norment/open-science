#!/bin/bash

module load python2.gnu/2.7.15

echo "Running from ${PWD}"

DIAG=`basename $1 | awk -F . '{print $1}' | awk -F _ '{print $1 "_" $2 "_" $3}'`
DIAGFILE="${DIAG}_munged.sumstats.gz"

COMPTYPE=`expr substr $2 72 2`
COMPN=`basename $2 | awk -F _ '{print $3}'`

SUMSTATDIR="/cluster/projects/p33/users/dtroelfs/NORMENT/2nd_article/sumstats"
RESOURCEDIR="/cluster/projects/p33/users/dtroelfs/resources"
LDSCDIR="/cluster/projects/p33/users/dtroelfs/software/python/ldsc"

echo "Running comparison between ${COMPTYPE}${COMPN} and ${DIAG}"

# Run LDSC
python2 ${LDSCDIR}/ldsc.py \
    --rg ${SUMSTATDIR}/${DIAGFILE},${2} \
    --ref-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
    --w-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
    --out ldsc_${DIAG}_by_${COMPTYPE}${COMPN}

