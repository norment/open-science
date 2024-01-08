#!/bin/bash

LOGDIR="${PWD}/ldsc_out_node"

rm LDSC_stats_node.txt

header=`cat ${LOGDIR}/ldsc_PGC_ASD_2017_by_node1.log | grep "p1"`
echo -e "GWAS\tdiagnosis\tnode\t${header}" | tee LDSC_stats_node.txt

for i in `ls ${LOGDIR}/ldsc*_by_node*.log`; do

	GWAS=`basename $i | awk -F _ '{print $2 "_" $3 "_" $4}'`
	DIAG=`basename $i | awk -F _ '{print $3}'`
	NODE=`basename $i | awk -F _ '{print $6}' | awk -F . '{print $1}'`

  file=$i
  linest=`cat $file | grep -n "p1" | gawk '{print $1}' FS=":"`
  lineno=$(( $linest + 1 ))
  stats=`cat $file | sed -n ${lineno}p`

  echo -e "${GWAS}\t${DIAG}\t${NODE}\t${stats}" | tee -a LDSC_stats_node.txt

  stats=""

done

