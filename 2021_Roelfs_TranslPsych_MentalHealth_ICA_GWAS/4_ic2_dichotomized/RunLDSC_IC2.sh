#!/bin/bash

# Set directories
BASEDIR="${PWD}"
SUMSTATDIR="${BASEDIR}/sumstats"
GWASLIST="${BASEDIR}/files/GWAS_LDSC.txt"
OUTDIR="${BASEDIR}/ldsc_out"

QGWAS="GWAS_IC2_dich_munged.sumstats.gz"
nDIAG=`cat $GWASLIST | wc -l`

for i in `seq $nDIAG`
do

	DIAG=`sed -n -e ${i}p ${GWASLIST}`

	bash ../RunLDSC_child.sh ${SUMSTATDIR}/${DIAG} ${SUMSTATDIR}/${QGWAS}

done

