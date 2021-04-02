#!/bin/bash

module load python2.gnu/2.7.15

OUTDIR="/ldsc_out"

SUMSTATDIR="/sumstats"
RESOURCEDIR="/resources"
LDSCDIR="/software/python/ldsc"

# Run LDSC
python2 ${LDSCDIR}/ldsc.py \
    --h2 ${SUMSTATDIR}/GWAS_IC2_dich_munged.sumstats.gz \
    --ref-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
    --w-ld-chr ${RESOURCEDIR}/eur_w_ld_chr/ \
    --out h2_IC_2_dich

