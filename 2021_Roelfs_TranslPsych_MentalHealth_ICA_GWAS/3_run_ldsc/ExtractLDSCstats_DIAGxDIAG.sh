#!/bin/bash

LOGDIR="/ldsc_out"

rm files/LDSC_stats_DIAGxDIAG.txt

header=`cat ${LOGDIR}/ldsc_DxD_PGC_ADHD_2017_by_PGC_ASD_2017.log | grep "p1"`
echo -e "DIAG1\tDIAG2\tcomparison${header}" | tee files/LDSC_stats_DIAGxDIAG.txt

for i in `ls ${LOGDIR}/ldsc_DxD*.log`; do

	DIAG1=`basename $i | awk -F _ '{print $4}'`
	DIAG2=`basename $i | awk -F _ '{print $8}'`
	comparison="${DIAG1}_by_${DIAG2}"

  file=$i
  linest=`cat $file | grep -n "p1" | gawk '{print $1}' FS=":"`
  lineno=$(( $linest + 1 ))
  stats=`cat $file | sed -n ${lineno}p`

  echo -e "${DIAG1}\t${DIAG2}\t${comparison}\t${stats}" | tee -a files/LDSC_stats_DIAGxDIAG.txt

  stats=""

done

