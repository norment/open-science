#!/bin/bash

LOGDIR="/ldsc_out"

rm files/LDSC_stats_ICxIC.txt

header=`cat ${LOGDIR}/ldsc_IC1_by_IC2.log | grep "p1"`
echo -e "ICx\tICy\tcomparison${header}" | tee files/LDSC_stats_ICxIC.txt

for i in `ls ${LOGDIR}/ldsc_IC*_by_IC*.log`; do

	ICX=`basename $i | awk -F _ '{print $2}'`
	ICY=`basename $i | awk -F _ '{print $4}' | awk -F . '{print $1}'`
	comparison="${ICX}_by_${ICY}"

  file=$i
  linest=`cat $file | grep -n "p1" | gawk '{print $1}' FS=":"`
  lineno=$(( $linest + 1 ))
  stats=`cat $file | sed -n ${lineno}p`

  echo -e "${ICX}\t${ICY}\t${comparison}\t${stats}" | tee -a files/LDSC_stats_ICxIC.txt

  stats=""

done

