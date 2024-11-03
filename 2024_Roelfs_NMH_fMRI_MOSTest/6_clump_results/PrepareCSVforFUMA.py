### PREPARE FDR CSV FOR FUMA ########################

# -- Libraries -------------------------

import pandas as pd
import sys

# -- Convert data -------------------------

infile = sys.argv[1]
outname = sys.argv[2]

data = pd.read_csv(infile, sep='\t')
data['FDR'] = data['FDR'] / 100000
data = data.rename(columns={'LEAD_SNP': 'rsid', 'CHR': 'chr', 'LEAD_BP': 'pos'})

# -- Write to file -------------------------

data.to_csv(outname, index=False, sep='\t')

