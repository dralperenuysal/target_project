import pandas as pd

orthogroups = 'output/orthofinder/Results_Feb22/Orthogroups/Orthogroups.tsv'
gene_count = 'output/orthofinder/Results_Feb22/Orthogroups/Orthogroups.GeneCount.tsv'
singletone = 'output/orthofinder/Results_Feb22/Orthogroups/Orthogroups_UnassignedGenes.tsv'

# Read the orthogroups data
ortho = pd.read_csv(orthogroups, sep='\t', header='infer')

# Clean the NaN values with changing them to blank value
filled_ortho = ortho.fillna("")

# Choose the orthogroups inlcuding at least one gene for each organism
common_ortho = ortho.dropna()

# Read the gene count
gene = pd.read_csv(gene_count, sep='\t', header='infer')

# Read the singletone
unassigned = pd.read_csv(singletone, sep='\t', header='infer')

# Get the orthogroups seperately
hi_ortho = ortho[['Orthogroup', 'hi_protein']]
pa_ortho = ortho[['Orthogroup', 'pa_protein']]
sa_mrsa_ortho = ortho[['Orthogroup', 'sa_mrsa_protein']]

hi_ortho['organism'] = "H.influenzae"
pa_ortho['organism'] = "P.aeruginosa"
sa_mrsa_ortho['organism'] = "MRSA"

# Drop NaN values in each organism dataframe
hi_ortho_drop = hi_ortho.dropna()
pa_ortho_drop = pa_ortho.dropna()
sa_mrsa_ortho_drop = sa_mrsa_ortho.dropna()

# Save the orthogroups as a txt file for further Venn diagram creation
hi_ortho_drop.Orthogroup.to_csv("output/orthofinder/hi_ortho.txt", sep='\n', index = False)
pa_ortho_drop.Orthogroup.to_csv("output/orthofinder/pa_ortho.txt", sep='\n', index = False)
sa_mrsa_ortho_drop.Orthogroup.to_csv("output/orthofinder/sa_mrsa_ortho.txt", sep='\n', index = False)

hi_ortho_drop.rename(columns={"hi_protein": "protein"}, inplace=True)
pa_ortho_drop.rename(columns={"pa_protein": "protein"}, inplace=True)
sa_mrsa_ortho_drop.rename(columns={"sa_mrsa_protein": "protein"}, inplace=True)

# Concat the orthogroups
concat = pd.concat([hi_ortho_drop, pa_ortho_drop, sa_mrsa_ortho_drop], axis=0)
