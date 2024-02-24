import pandas as pd

# Define the paths of the masked genomes
masked_hi = "output/repeatmasker/hi_masked/hi_genome.fasta.out.csv"
masked_pa = "output/repeatmasker/pa_masked/pa_genome.fasta.out.csv"
masked_sa_mrsa = "output/repeatmasker/sa_mrsa_masked/sa_mrsa_genome.fasta.out.csv"

# Read the data
hi = pd.read_csv(masked_hi, sep=",", header= 'infer', index_col=0)
pa = pd.read_csv(masked_pa, sep=",", header= 'infer', index_col=0)
sa_mrsa = pd.read_csv(masked_sa_mrsa, sep=",", header= 'infer', index_col=0)

