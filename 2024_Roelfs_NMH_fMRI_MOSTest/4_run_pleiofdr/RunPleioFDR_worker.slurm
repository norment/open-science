#!/bin/bash

#SBATCH --job-name=RunPleioFDR_worker
#SBATCH --time=03:00:00

module load python2.gnu/2.7.16
module load matlab/R2017a

echo "Submitted from ${SUBMITDIR}"
echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"

SUMSTATDIR="${SUBMITDIR}/sumstats"
OUTDIR="${SUBMITDIR}/pleio_out"
PLEIODIR="${SOFTWAREDIR}/pleiofdr"
GWASLIST="${SUBMITDIR}/GWAS_pleio.txt"

DIAG=`sed -n -e ${SLURM_ARRAY_TASK_ID}p ${GWASLIST}`
basename=`basename $DIAG | awk -F .gz '{print $1}'`
diagfile=`echo $basename.mat`
diagname=`basename $DIAG | awk -F . '{print $1}'`

# copy files to job directory
cp ${PLEIODIR}/* ${SCRATCH}/
cp ${PLEIODIR}/config_default.txt ${SCRATCH}/config.txt

# cd to job directory
cd $SCRATCH

ls

for i in `seq 2`; do

	if [[ $i == 1 ]]; then
		QGWAS="edge_mostest_PleioFDR.sumstats.mat"
		FMRINAME="MOSTest_edge"
	else
		QGWAS="node_mostest_PleioFDR.sumstats.mat"
		FMRINAME="MOSTest_node"
	fi

	cp ${PLEIODIR}/config_default.txt ./config.txt

	REFFILE="resources/ref9545380_1kgPhase3eur_LDr2p1.mat"
	REFINFO="resources/9545380.ref"
	TRAITFILE=${QGWAS}
	TRAITNAME1=${FMRINAME}
	TRAITFILES=${diagfile}
	TRAITNAMES=${diagname}
	TRAITFOLDER=${SUMSTATDIR}/
	python ${SUBMITDIR}/ModifyConfigFile.py $REFFILE $TRAITFILE $TRAITNAME1 $TRAITFILES $TRAITNAMES $TRAITFOLDER $REFINFO

	head config.txt

	matlab -nodisplay -nodesktop -nosplash < runme.m

	mv results/ ${OUTDIR}/results_${diagname}_${FMRINAME}

done


