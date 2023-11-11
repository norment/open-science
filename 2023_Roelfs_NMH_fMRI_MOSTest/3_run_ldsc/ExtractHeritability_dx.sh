#!/bin/bash

LOGDIR="./ldsc_out_dx"

OUTFILE="LDSC_h2_dx.txt"

rm ${OUTFILE}

echo -e "dx\th2\tse\tLambdaGC\tintercept\tintercept_se" | tee ${OUTFILE}

for i in `ls ${LOGDIR}/h2_*.log`; do

	DX=`basename $i .log | awk -F _ '{print $3}'`

  fm=`cat ${i} | grep "scale h2" | head -1`
  h2=`echo $fm | sed -e 's/.*h2:\(.*\)(.*)/\1/'`
  se=`echo $fm | sed -e 's/.*h2:\s\(.*\)/\1/' | awk -F"[()]" '{print $2}'`
	lGC=`cat ${i} | grep "Lambda GC" | sed -e 's/^.*GC: //p' | head -1`
  intl=`cat ${i} | grep "Intercept"`
	int=`echo $intl | sed -e 's/.*Intercept: \(.*\)(.*)/\1/'`
  int_se=`echo $intl | sed -e 's/.*Intercept:\s\(.*\)/\1/' | awk -F"[()]" '{print $2}'`

  echo -e "${DX}\t${h2}\t${se}\t${lGC}\t${int}\t${int_se}" | tee -a ${OUTFILE}

done


