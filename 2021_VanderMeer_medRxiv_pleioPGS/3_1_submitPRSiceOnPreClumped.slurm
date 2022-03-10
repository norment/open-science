#!/bin/bash

#SBATCH --job-name=PGRS
#SBATCH --account=p33
#SBATCH --time=10:00:00
#SBATCH --mem-per-cpu=24G

module purge 
module load plink
module load R/3.4.0

HOME=/cluster/projects/p33/users/dennisva/PleioSZ
maf=maf05
trait=SCZ
Version=PGC3
traitsumstat=PGC_SCZ_0518_EUR_noTOP.STD

### column selection primary trait gwas
awk -F"\t" '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $10}' ${HOME}/Sumstats/${traitsumstat} > ${HOME}/PRS/SumStats/SZ4PRS_${Version}.txt

# filter primary GWAS sumstat to only retain lead SNPs from clumping (join), sort on significance and run polygenic scoring script for top n SNPs  

##### cFDR
join -1 1 -2 3 -o 1.1,1.2,1.3,1.4,1.5,1.6,1.7,2.5 <(sort -k1,1 ${HOME}/PRS/SumStats/SZ4PRS_${Version}.txt) <(sort -k3,3 ${HOME}/PRS/Clumps/${Version}/SCZvMOSTcFDR_${Version}.clump_1_${maf}.clumped) > ${HOME}/PRS/SumStats/${trait}_CondFDRLeads4PRS_${Version}_${maf}.sumstats
sort -g -k8 ${HOME}/PRS/SumStats/${trait}_CondFDRLeads4PRS_${Version}_${maf}.sumstats > ${HOME}/PRS/SumStats/${trait}_CondFDRLeads4PRS_${Version}_sorted_${maf}.sumstats
for nsnps in {1000..128000..1000}; do 
sbatch --export=ALL,maf=${maf},nsnps=${nsnps},trait=${trait},Version=${Version} ${HOME}/Scripts/3_2_PRSiceOnPreClumped_cFDR_TopSNPs.slurm
done

##### Trait (SCZ)
join -1 1 -2 3 -o 1.1,1.2,1.3,1.4,1.5,1.6,1.7,2.5 <(sort -k1,1 ${HOME}/PRS/SumStats/SZ4PRS_${Version}.txt) <(sort -k3,3 ${HOME}/PRS/Clumps/${Version}/${traitsumstat}.clump_1_${maf}.clumped) > ${HOME}/PRS/SumStats/${trait}_TraitLeads4PRS_${Version}_${maf}.sumstats
sort -g -k8 ${HOME}/PRS/SumStats/${trait}_TraitLeads4PRS_${Version}_${maf}.sumstats > ${HOME}/PRS/SumStats/${trait}_TraitLeads4PRS_${Version}_sorted_${maf}.sumstats
for nsnps in {1000..128000..1000}; do   
sbatch --export=ALL,maf=${maf},nsnps=${nsnps},trait=${trait},Version=${Version} ${HOME}/Scripts/4_3_PRSiceOnPreClumped_${trait}_TopSNPs.slurm
done

##### Brain
join -1 1 -2 3 -o 1.1,1.2,1.3,1.4,1.5,1.6,1.7,2.5 <(sort -k1,1 ${HOME}/PRS/SumStats/SZ4PRS_${Version}.txt) <(sort -k3,3 ${HOME}/PRS/Clumps/${Version}/UKB42k_MOSTest_${Version}.STD.clump_1_${maf}.clumped) > ${HOME}/PRS/SumStats/${trait}_MOSTestLeads4PRS_${Version}_${maf}.sumstats
sort -g -k8 ${HOME}/PRS/SumStats/${trait}_MOSTestLeads4PRS_${Version}_${maf}.sumstats > ${HOME}/PRS/SumStats/${trait}_MOSTestLeads4PRS_${Version}_sorted_${maf}.sumstats
for nsnps in {1000..128000..1000}; do 
sbatch --export=ALL,maf=${maf},nsnps=${nsnps},trait=${trait},Version=${Version} ${HOME}/Scripts/4_2_PRSiceOnPreClumped_MOSTest_TopSNPs.slurm
done

