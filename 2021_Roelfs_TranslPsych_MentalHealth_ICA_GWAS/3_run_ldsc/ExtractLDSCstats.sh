#!/bin/bash

LOGDIR="/ldsc_out"

rm files/LDSC_stats.txt

header=`cat ${LOGDIR}/ldsc_PGC_BIP_2016_by_IC1.log | grep "p1"`
echo -e "GWAS\tdiagnosis\tcomponent\t${header}" | tee files/LDSC_stats.txt

for i in `ls ${LOGDIR}/ldsc*20[0-2][0-9]_by_IC*.log`; do

	GWAS=`basename $i | awk -F _ '{print $2 "_" $3 "_" $4}'`
	DIAG=`basename $i | awk -F _ '{print $3}'`
	COMP=`basename $i | awk -F _ '{print $6}' | awk -F . '{print $1}'`

  file=$i
  linest=`cat $file | grep -n "p1" | gawk '{print $1}' FS=":"`
  lineno=$(( $linest + 1 ))
  stats=`cat $file | sed -n ${lineno}p`

  echo -e "${GWAS}\t${DIAG}\t${COMP}\t${stats}" | tee -a files/LDSC_stats.txt

  stats=""

done

