#!/bin/sh

#SBATCH --job-name=MungeSumstats_ICA_worker
#SBATCH --account=p33_norment_dev
#SBATCH --time=01:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=8GB
#SBATCH --cpus-per-task=1

module load python2.gnu/2.7.15

echo "Submitted from ${SUBMITDIR}"
echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"

OUTDIR="${SUBMITDIR}/sumstats"

RESOURCEDIR="/resources"
GENDIR="/ukbio/genetics/UKB500k_300120"
PYCONVDIR="/software/python/python_convert"
LDSCDIR="/software/python/ldsc"

cd $SCRATCH

echo "Adding headers to allele reference file"
echo -e "CHR\tSNP\tCM\tBP\tA1\tA2\n$(cat ${GENDIR}/UKB500k_QCed_300120.bim)" > UKB500k_QCed_300120_WH.bim
head UKB500k_QCed_300120_WH.bim

# Prepare ICA data
python2 ${PYCONVDIR}/sumstats.py csv \
    --sumstats ${SUBMITDIR}/gwas_out/GWAS_IC${SLURM_ARRAY_TASK_ID}.IC${SLURM_ARRAY_TASK_ID}.glm.linear \
    --out GWAS_IC${SLURM_ARRAY_TASK_ID}.glm.linear.STD \
    --force --auto --head 5 \
		--n OBS_CT --chr \#CHROM --bp POS --a1 A1 --a2 REF --snp ID
python2 ${PYCONVDIR}/sumstats.py qc \
    --sumstats GWAS_IC${SLURM_ARRAY_TASK_ID}.glm.linear.STD \
    --out GWAS_IC${SLURM_ARRAY_TASK_ID}.glm.linear.STD.noMHC \
    --exclude-ranges 6:26000000:34000000 \
    --force

python2 ${PYCONVDIR}/sumstats.py zscore \
    --sumstats GWAS_IC${SLURM_ARRAY_TASK_ID}.glm.linear.STD.noMHC \
    --out GWAS_IC${SLURM_ARRAY_TASK_ID}.glm.linear.STD.noMHC.Z \
    --force
python2 ${PYCONVDIR}/sumstats.py rs \
    --sumstats GWAS_IC${SLURM_ARRAY_TASK_ID}.glm.linear.STD.noMHC.Z \
    --ref UKB500k_QCed_300120_WH.bim \
    --out ToMunge.sumstats \
    --force --a1a2

head ToMunge.sumstats
wc -l ToMunge.sumstats
gzip ToMunge.sumstats

python2 ${LDSCDIR}/munge_sumstats.py \
    --sumstats ToMunge.sumstats.gz \
    --merge-alleles ${RESOURCEDIR}/w_hm3.noMHC.snplist \
    --ignore BETA \
    --out GWAS_IC${SLURM_ARRAY_TASK_ID}_munged

#rsync -a GWAS_IC${SLURM_ARRAY_TASK_ID}_munged.log ${OUTDIR}/
rsync -a ToMunge.sumstats.gz ${OUTDIR}/GWAS_IC${SLURM_ARRAY_TASK_ID}.sumstats.gz
rsync -a GWAS_IC${SLURM_ARRAY_TASK_ID}_munged.sumstats.gz ${OUTDIR}/

