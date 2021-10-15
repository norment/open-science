#!/bin/bash

#SBATCH --job-name=Submit_Pleio
#SBATCH --account=p33_norment_dev
#SBATCH --time=1:00:00
#SBATCH --mem-per-cpu=4G

module purge

Batch=42k
Date=160320
HOME=/cluster/projects/p33/users/dennisva
SUMDIR=${HOME}/UKB/SumStats/PleioSZ/Formatted
SCRIPTDIR=${HOME}/PleioSZ/Scripts/pleiofdr

Version=PGC3
Primary=PGC_SCZ_0518_EUR_noTOP

cd ${SCRIPTDIR}

i=UKB${Batch}_MOSTest_${Version}.mat
Pheno=${i%".mat"}
cp ${SCRIPTDIR}/config_default.txt ${SCRIPTDIR}/IndConfig/config_${Pheno}.txt
sed -i "s/PHENO/${Pheno}/g" ${SCRIPTDIR}/IndConfig/config_${Pheno}.txt
sed -i "s/PRIMARY/${Primary}/g" ${SCRIPTDIR}/IndConfig/config_${Pheno}.txt
sbatch --export=ALL,Pheno=${Pheno},Primary=${Primary} ${HOME}/PleioSZ/Scripts/1_2_runPleioFDR.slurm











