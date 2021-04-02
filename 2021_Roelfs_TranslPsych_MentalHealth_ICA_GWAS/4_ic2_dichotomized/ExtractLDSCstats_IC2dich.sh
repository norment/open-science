#!/bin/bash

LOGDIR="/IC2_dich"

rm LDSC_stats_IC2dich.txt

header=`cat ${LOGDIR}/ldsc_ANGST_ANX_2016_by_IC2.log | grep "p1"`
echo -e "GWAS\tdiagnosis\tcomponent\t${header}" | tee LDSC_stats_IC2dich.txt

for i in `ls ${LOGDIR}/ldsc*20[0-2][0-9]_by_IC2.log`; do

	GWAS=`basename $i | awk -F _ '{print $2 "_" $3 "_" $4}'`
	DIAG=`basename $i | awk -F _ '{print $3}'`
	COMP=`basename $i | awk -F _ '{print $6}' | awk -F . '{print $1}'`

  file=$i
  linest=`cat $file | grep -n "p1" | gawk '{print $1}' FS=":"`
  lineno=$(( $linest + 1 ))
  stats=`cat $file | sed -n ${lineno}p`

  echo -e "${GWAS}\t${DIAG}\t${COMP}\t${stats}" | tee -a LDSC_stats_IC2dich.txt

  stats=""

done

