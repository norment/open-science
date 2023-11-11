#!/bin/bash

module load python3.gnu/3.7.3

OUTDIR="${PWD}/converted"

for i in `ls ${OUTDIR}/fdrmat2csv_*.csv`
do

	echo "Converting ${i}"
	
	diag=`basename ${i} | awk -F "_" '{print $2 "_" $3 "_" $4}'`
	feature=`basename ${i} .csv | awk -F "_" '{print $6}'`

	csv_outname="fuma_${feature}_and_${diag}_div100k.csv"
	python3 PrepareCSVforFUMA.py ${i} ${OUTDIR}/${csv_outname}

	lead_inname="clumped_${diag}_and_${feature}.lead.csv"
	lead_outname="fuma_${diag}_and_${feature}.lead.csv"
	python3 PrepareLEADforFUMA.py ${OUTDIR}/${lead_inname} ${OUTDIR}/${lead_outname}

done
