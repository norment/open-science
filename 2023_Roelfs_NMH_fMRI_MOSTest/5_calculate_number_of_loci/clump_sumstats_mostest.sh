#!/bin/bash

module load python2.gnu/2.7.16
module load plink

INDIR="${PROJECTDIR}/mostest/mostest_out"
OUTDIR="${PROJECTDIR}/nloci/multivariate"
PYCONVDIR="${SOFTWAREDIR}/python_convert"

for i in `ls ${INDIR}/*_mostest.*_orig.sumstats.gz`; do

	MOST=`basename $i | awk -F . '{print $1 "_" $2}'`

	echo "Clumping sumstats for $MOST"

	python ${PYCONVDIR}/sumstats.py clump \
  	--sumstats $i \
  	--plink plink \
  	--bfile-chr resources/ref_1kG_phase3_EUR/chr@ \
  	--exclude-ranges 6:25000000:33000000 \
	  --clump-field PVAL \
	  --clump-p1 5e-08 \
	  --out ${OUTDIR}/${MOST}_clumped \
	  --force

done

