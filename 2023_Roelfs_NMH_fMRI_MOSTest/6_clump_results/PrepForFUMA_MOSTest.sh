#!/bin/bash

module load python2.gnu/2.7.16

INDIR="../mostest/mostest_out"
OUTDIR="${PWD}/converted"
PYCONVDIR="${SOFTWAREDIR}/python_convert"

python ${PYCONVDIR}/sumstats.py csv \
    --sumstats ${INDIR}/edge_mostest.most_orig.sumstats.gz \
    --out ${OUTDIR}/edge_mostest.most_orig.sumstats.fuma \
    --force --auto --head 5
gzip ${OUTDIR}/edge_mostest.most_orig.sumstats.fuma

python ${PYCONVDIR}/sumstats.py csv \
    --sumstats ${INDIR}/node_mostest.most_orig.sumstats.gz \
    --out ${OUTDIR}/node_mostest.most_orig.sumstats.fuma \
    --force --auto --head 5
gzip ${OUTDIR}/node_mostest.most_orig.sumstats.fuma

