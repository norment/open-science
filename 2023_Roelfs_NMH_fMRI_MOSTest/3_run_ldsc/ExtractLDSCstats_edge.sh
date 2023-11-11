#!/bin/bash

LOGDIR="${PWD}/ldsc_out_edge"

rm LDSC_stats_edge.txt

header=`cat ${LOGDIR}/ldsc_PGC_ASD_2017_by_edge1.log | grep "p1"`
echo -e "GWAS\tdiagnosis\tedge\t${header}" | tee LDSC_stats_edge.txt

for i in `ls ${LOGDIR}/ldsc*_by_edge*.log`; do

	GWAS=`basename $i | awk -F _ '{print $2 "_" $3 "_" $4}'`
	DIAG=`basename $i | awk -F _ '{print $3}'`
	EDGE=`basename $i | awk -F _ '{print $6}' | awk -F . '{print $1}'`

  file=$i
  linest=`cat $file | grep -n "p1" | gawk '{print $1}' FS=":"`
  lineno=$(( $linest + 1 ))
  stats=`cat $file | sed -n ${lineno}p`

  echo -e "${GWAS}\t${DIAG}\t${EDGE}\t${stats}" | tee -a LDSC_stats_edge.txt

  stats=""

done

