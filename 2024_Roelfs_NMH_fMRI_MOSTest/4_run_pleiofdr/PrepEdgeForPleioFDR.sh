#!/bin/bash

module load python2.gnu/2.7.16

INDIR="../mostest/mostest_out"
OUTDIR="sumstats"
PYCONVDIR="${SOFTWAREDIR}/python_convert"
REFFILE="resources/9545380.ref"

python ${PYCONVDIR}/sumstats.py csv --auto --sumstats ${INDIR}/edge_mostest.most_orig.sumstats.gz --out ${OUTDIR}/edge_mostest_PleioFDR.sumstats.csv --force
python ${PYCONVDIR}/sumstats.py mat --sumstats ${OUTDIR}/edge_mostest_PleioFDR.sumstats.csv --ref ${REFFILE} --out ${OUTDIR}/edge_mostest_PleioFDR.sumstats.mat --force


