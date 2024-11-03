#!/bin/bash

module load python2.gnu/2.7.15
module load plink

PYCONVDIR="${SOFTWAREDIR}/python_convert"

python ${PYCONVDIR}/sumstats.py clump \
  --sumstats $1 \
  --bfile-chr resources/ref_1kG_phase3_EUR/chr@ \
  --plink plink \
  --exclude-ranges 6:25000000:33000000 \
  --clump-field PVAL \
  --clump-p1 5e-08 \
  --out $2 \
  --force

