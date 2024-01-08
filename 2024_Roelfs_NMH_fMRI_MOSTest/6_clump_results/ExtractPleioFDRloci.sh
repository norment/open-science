#!/bin/bash

INDIR="converted"
OUTDIR="files"

rm files/pleioFDR_loci.txt

header="mostest\tdiag\tlocusnum\tchr\tlead_snp\tlead_bp\tminbp\tmaxbp\tFDR"
echo -e $header | tee ${OUTDIR}/pleioFDR_loci.txt

for i in `ls ${INDIR}/clumped_*.loci.csv`
do

	FEATURE=`basename $i .loci.csv | awk -F _ '{print $NF}'`
	DIAG=`basename $i | awk -F _ '{print $2 "_" $3 "_" $4}'`

	nlines=`cat $i | wc -l`

	for j in `seq 2 $nlines`
	do
		
		l=`sed -n -e ${j}p ${i}`
		echo -e "${FEATURE}\t${DIAG}\t${l}" | tee -a ${OUTDIR}/pleioFDR_loci.txt

	done

done

