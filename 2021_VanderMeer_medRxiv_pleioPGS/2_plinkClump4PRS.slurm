#!/bin/bash
#SBATCH --job-name=clump
#SBATCH --account=p33
#SBATCH --time=24:00:00
#SBATCH --mem-per-cpu=32G

HOME=/cluster/projects/p33/users/dennisva
SCRIPTDIR=${HOME}/PleioSZ/Scripts
STATDIR=${HOME}/PleioSZ/Sumstats
PYDIR=${HOME}/Software/python_convert-master
Version=PGC3
Sumstat=PGC_SCZ_0518_EUR_noTOP
maf=05

##### Convert cFDR result file to csv
module load python3.gnu
python3 ${SCRIPTDIR}/fdrmat2csv.py ${SCRIPTDIR}/pleiofdr/UKB42k_MOSTest_${Version}/result.mat ${HOME}/Software/pleiofdr/9545380.ref
mv ${SCRIPTDIR}/pleiofdr/UKB42k_MOSTest_${Version}/result.mat.csv ${HOME}/PleioSZ/FDR/SCZvMOSTcFDR_${Version}.csv

module load python2.gnu/2.7.15
module load plink/1.90b6.2

##### Make clump base file using only cFDR SNPs (intersection MOSTest and SCZ SNPs)
plink --bfile ${HOME}/Software/ref_1kG_phase3_EUR/all --extract ${HOME}/PleioSZ/Gen/cFDRsnps_${Version}.txt --make-bed --out ${HOME}/Software/ref_1kG_phase3_EUR/cFDRsnps_${Version}

### clump GWAS both traits
for sumstat in ${Sumstat}.STD UKB42k_MOSTest_${Version}.STD; do
plink --bfile ${HOME}/Software/ref_1kG_phase3_EUR/cFDRsnps_${Version} \
    --maf 0.${maf} \
	--clump ${STATDIR}/${sumstat} \
	--clump-field PVAL \
	--clump-p1 1 \
	--clump-p2 1 \
	--clump-r2 0.10 \
	--clump-kb 500 \
	--out ${HOME}/PleioSZ/PRS/Clumps/${Version}/${sumstat}.clump_${thresh}_maf${maf}
done

### clump condFDR
plink --bfile ${HOME}/Software/ref_1kG_phase3_EUR/cFDRsnps_${Version} \
	--maf 0.${maf} \
	--clump ${HOME}/PleioSZ/FDR/SCZvMOSTcFDR_${Version}.csv \
	--clump-field FDR \
	--clump-p1 1 \
	--clump-p2 1 \
	--clump-r2 0.10 \
	--clump-kb 500 \
	--out ${HOME}/PleioSZ/PRS/Clumps/${Version}/SCZvMOSTcFDR_${Version}.clump_${thresh}_maf${maf}

