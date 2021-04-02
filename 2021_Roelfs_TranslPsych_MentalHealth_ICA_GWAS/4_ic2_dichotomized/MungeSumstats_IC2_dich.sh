#!/bin/bash

module load python2.gnu/2.7.15

OUTDIR="/sumstats"

RESOURCEDIR="/resources"
GENDIR="/ukbio/genetics/UKB500k_300120"
PYCONVDIR="/software/python/python_convert"
LDSCDIR="/software/python/ldsc"

# Prepare ICA data
python2 ${PYCONVDIR}/sumstats.py csv \
    --sumstats gwas_out/GWAS.IC2_dich.glm.logistic \
    --out GWAS_IC2_dich.glm.logistic.STD \
    --force --auto --head 5 \
		--n OBS_CT --chr \#CHROM --bp POS --a1 A1 --a2 REF --snp ID
python2 ${PYCONVDIR}/sumstats.py qc \
    --sumstats GWAS_IC2_dich.glm.logistic.STD \
    --out GWAS_IC2_dich.glm.logistic.STD.noMHC \
    --exclude-ranges 6:26000000:34000000 \
    --force

python2 ${PYCONVDIR}/sumstats.py zscore \
    --sumstats GWAS_IC2_dich.glm.logistic.STD.noMHC \
    --out GWAS_IC2_dich.glm.logistic.STD.noMHC.Z \
    --force
python2 ${PYCONVDIR}/sumstats.py rs \
    --sumstats GWAS_IC2_dich.glm.logistic.STD.noMHC.Z \
    --ref ${RESOURCEDIR}/UKB500k_QCed_300120_WH.bim \
    --out ToMunge.sumstats \
    --force --a1a2

python2 ${LDSCDIR}/munge_sumstats.py \
    --sumstats ToMunge.sumstats \
    --merge-alleles ${RESOURCEDIR}/w_hm3.noMHC.snplist \
    --ignore OR \
    --out GWAS_IC2_dich_munged

gzip -f ToMunge.sumstats

rsync -a ToMunge.sumstats.gz ${OUTDIR}/GWAS_IC2_dich.sumstats.gz
rsync -a GWAS_IC2_dich_munged.sumstats.gz ${OUTDIR}/

