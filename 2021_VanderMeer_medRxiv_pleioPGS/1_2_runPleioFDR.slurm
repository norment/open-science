#!/bin/bash

#SBATCH --job-name=Pleio
#SBATCH --account=p33
#SBATCH --time=1:00:00
#SBATCH --mem-per-cpu=60G

#source /cluster/software/lmod/lmod/init/profile

module purge 
#set -o errexit

module load python2.gnu/2.7.15
module load matlab

HOME=/cluster/projects/p33/users/dennisva/PleioSZ/Scripts/pleiofdr
cd ${HOME}

cp runme.m runme_${Pheno}.m
sed -i "s/PRIMARY/${Pheno}/g" runme_${Pheno}.m
matlab -nodisplay -nosplash < runme_${Pheno}.m
