#!/bin/bash

INDIR="${PWD}"

rm clumped_loci.txt

header="method\tfeature\tlocusnum\tCHR\tLEAD_SNP\tLEAD_BP\tMinBP\tMaxBP\tPVAL"
echo -e $header | tee clumped_loci.txt

for i in `ls multivariate/*.loci.csv`; do
	
	file="$i"
	method=`basename $file | awk -F _ '{print $3}'`
	feature=`basename $file | awk -F _ '{print $1}'`

	sed 1d $file | while read line
	do
		
		newline="$method\t$feature\t$line"
		echo -e $newline | tee -a clumped_loci.txt

	done

done

