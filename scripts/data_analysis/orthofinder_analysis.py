import pandas as pd

orthogroups = 'output/orthofinder/Results_Feb17/Orthogroups/Orthogroups.tsv'
gene_count = 'output/orthofinder/Results_Feb17/Orthogroups/Orthogroups.GeneCount.tsv'
singletone = 'output/orthofinder/Results_Feb17/Orthogroups/Orthogroups_UnassignedGenes.tsv'

# Read the orthogroups data
ortho = pd.read_csv(orthogroups, sep='\t', index_col=0, header='infer')

# Clean the NaN values with changing them to blank value
filled_ortho = ortho.fillna("")

# Choose the orthogroups inlcuding at least one gene for each organism
common_ortho = ortho.dropna()