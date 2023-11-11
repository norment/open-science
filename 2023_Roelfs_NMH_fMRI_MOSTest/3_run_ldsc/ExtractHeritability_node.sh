#!/bin/bash

cd ${PROJECTDIR}/ldsc

# Extract heritability

LOGDIR="${PROJECTDIR}/ldsc/ldsc_out_node"

rm LDSC_h2_node.txt

echo -e "calc\tnode\th2\tse\tLambdaGC\tintercept\tintercept_se" | tee LDSC_h2_node.txt

for i in `ls ${LOGDIR}/h2_*.log`; do

	CALC=`basename $i | awk -F _ '{print $2}'`
	NODE=`basename $i | awk -F _ '{print $3}' | awk -F . '{print $1}'`

  fm=`cat ${i} | grep "scale h2" | head -1`
  h2=`echo $fm | sed -e 's/.*h2:\(.*\)(.*)/\1/'`
  se=`echo $fm | sed -e 's/.*h2:\s\(.*\)/\1/' | awk -F"[()]" '{print $2}'`
	lGC=`cat ${i} | grep "Lambda GC" | sed -e 's/^.*GC: //p' | head -1`
  intl=`cat ${i} | grep "Intercept"`
	int=`echo $intl | sed -e 's/.*Intercept: \(.*\)(.*)/\1/'`
  int_se=`echo $intl | sed -e 's/.*Intercept:\s\(.*\)/\1/' | awk -F"[()]" '{print $2}'`

  echo -e "${CALC}\t${NODE}\t${h2}\t${se}\t${lGC}\t${int}\t${int_se}" | tee -a LDSC_h2_node.txt

done


