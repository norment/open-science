#!/bin/bash

INDIR="${PROJECTDIR}/nloci"

rm files/clumped_loci_diag.txt

header="gwas\tlocusnum\tCHR\tLEAD_SNP\tLEAD_BP\tMinBP\tMaxBP\tPVAL"
echo -e $header | tee clumped_loci_diag.txt

for i in `ls diag/*.loci.csv`
do
	
	file="$i"
	gwas=`basename $file | awk -F _ '{print $1 "_" $2 "_" $3}' | awk -F . '{print $1}'`

	sed 1d $file | while read line
	do
		
		newline="$gwas\t$line"
		echo -e $newline | tee -a clumped_loci_diag.txt

	done

done

