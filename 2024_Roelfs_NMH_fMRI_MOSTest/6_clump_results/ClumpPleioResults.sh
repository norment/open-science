#!/bin/bash

module load plink/1.90b6.2
module load python2.gnu/2.7.16

INDIR="../pleiofdr/pleio_out"
OUTDIR="${PWD}/converted"
PYCONVDIR="${SOFTWAREDIR}/python_convert"
BFILE="resources/ref_1kG_phase3_EUR/chr@"
REFFILE="resources/9545380.ref"

for i in `ls $INDIR`
do

	DIAG=`echo $i | awk -F _ '{print $2 "_" $3 "_" $4}'`
	FEATURE=`echo $i | awk -F _ '{print $NF}'`
	outname="clumped_${DIAG}_and_${FEATURE}"
	
	python2 ${PYCONVDIR}/fdrmat2csv.py \
		--mat ${INDIR}/${i}/result.mat \
		--ref ${REFFILE} \
		--out ${OUTDIR}/fdrmat2csv_${DIAG}_and_${FEATURE}.csv

	python2 ${PYCONVDIR}/sumstats.py clump \
  	--sumstats ${OUTDIR}/fdrmat2csv_${DIAG}_and_${FEATURE}.csv \
  	--bfile-chr ${BFILE} \
   	--plink plink \
  	--exclude-ranges 6:25000000-33000000 \
  	--clump-field FDR \
  	--clump-p1 0.05 \
  	--force \
  	--out ${OUTDIR}/${outname}

done

