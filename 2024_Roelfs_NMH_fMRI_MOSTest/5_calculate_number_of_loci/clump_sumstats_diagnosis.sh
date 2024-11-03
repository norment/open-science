#!/bin/bash

module load python2.gnu/2.7.16
module load plink

INDIR="${PROJECTDIR}/pleiofdr/sumstats/raw"
OUTDIR="${PROJECTDIR}/nloci/diag"
PYCONVDIR="${SOFTWAREDIR}/python_convert"

for i in `ls ${INDIR}/*.sumstats.gz`; do

	DIAG=`basename $i | awk -F . '{print $1}' |awk -F _ '{print $1 "_" $2 "_" $3}'`

	echo "Clumping sumstats for $DIAG"

	python ${PYCONVDIR}/sumstats.py clump \
  	--sumstats $i \
  	--plink plink \
  	--bfile-chr resources/ref_1kG_phase3_EUR/chr@ \
  	--exclude-ranges 6:25000000:33000000 \
	  --clump-field PVAL \
	  --clump-p1 5e-08 \
	  --out ${OUTDIR}/${DIAG}_clumped \
	  --force

done

