#!/bin/bash

# Extract heritability

LOGDIR="/ldsc_out"

rm files/LDSC_h2.txt

echo -e "calc\tcomponent\th2\tse\tLambdaGC\tintercept\tintercept_se" | tee files/LDSC_h2.txt

for i in `ls ${LOGDIR}/h2_*.log`; do

	CALC=`basename $i | awk -F _ '{print $2}' | cut -c1-2`
	COMP=`basename $i | awk -F _ '{print $2}' | sed 's/[^0-9]*//g'`

  fm=`cat ${i} | grep "scale h2" | head -1`
  h2=`echo $fm | sed -e 's/.*h2:\(.*\)(.*)/\1/'`
  se=`echo $fm | sed -e 's/.*h2:\s\(.*\)/\1/' | awk -F"[()]" '{print $2}'`
	lGC=`cat ${i} | grep "Lambda GC" | sed -e 's/^.*GC: //p' | head -1`
  intl=`cat ${i} | grep "Intercept"`
	int=`echo $intl | sed -e 's/.*Intercept: \(.*\)(.*)/\1/'`
  int_se=`echo $intl | sed -e 's/.*Intercept:\s\(.*\)/\1/' | awk -F"[()]" '{print $2}'`

  echo -e "${CALC}\t${COMP}\t${h2}\t${se}\t${lGC}\t${int}\t${int_se}" | tee -a files/LDSC_h2.txt

done


