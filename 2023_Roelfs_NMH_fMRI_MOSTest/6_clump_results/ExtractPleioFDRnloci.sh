#!/bin/bash

INDIR="converted"
OUTDIR="files"

rm files/pleioFDR_nloci.txt

echo -e "mostest\tdiagnosis\tnloci" | tee ${OUTDIR}/pleioFDR_nloci.txt

for i in `ls ${INDIR}/clumped_*.loci.csv`
do

	FEATURE=`basename $i .loci.csv | awk -F _ '{print $NF}'`
	DIAG=`basename $i | awk -F _ '{print $2 "_" $3 "_" $4}'`

	nlines=`cat $i | wc -l`
	nloci=`cat $i | awk '/./{line=$0} END{print line}' | awk '{print $1}'`

	echo -e "${FEATURE}\t${DIAG}\t${nloci}" | tee -a ${OUTDIR}/pleioFDR_nloci.txt

done

