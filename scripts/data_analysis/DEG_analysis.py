import pandas as pd

hi_path = "data/DEG/hi_deg.tsv"
pa_path = "data/DEG/pa_deg.tsv"
sa_mrsa_path = "data/DEG/sa_mrsa_deg.tsv"
bacterial_annotation = "data/DEG/deg_annotation_p.tsv" # Downloaded from DEG database

# Read the genomes
hi = pd.read_csv(hi_path, sep='\t', header= 'infer')
pa = pd.read_csv(pa_path, sep='\t', header='infer')
sa_mrsa = pd.read_csv(sa_mrsa_path, sep='\t', header= 'infer')

# Read the annotation data
annotation = pd.read_csv(bacterial_annotation, sep= '\t', header= 'infer')
annotation.drop(columns=['Unnamed: 13'], axis=0, inplace=True)

# Drop unrequired columns
hi = hi.drop(columns=['pct_identity', 's_start', 's_end', 'q_start', 'q_end', 'aln_length', 'gap_openings'])
pa = pa.drop(columns=['pct_identity', 's_start', 's_end', 'q_start', 'q_end', 'aln_length', 'gap_openings'])
sa_mrsa = sa_mrsa.drop(columns=['pct_identity', 's_start', 's_end', 'q_start', 'q_end', 'aln_length', 'gap_openings'])

# Annotate the essential genes
hi_merged = pd.merge(hi, annotation, on='subject_id', how='left')
pa_merged = pd.merge(pa, annotation, on='subject_id', how='left')
sa_mrsa_merged = pd.merge(sa_mrsa, annotation, on='subject_id', how='left')

# Save the merged and anootated data
hi_merged.to_csv('output/deg/hi_annotated.tsv', sep='\t', index=False)
pa_merged.to_csv('output/deg/pa_annotated.tsv', sep='\t', index=False)
sa_mrsa_merged.to_csv('output/deg/sa_mrsa_annotated.tsv', sep='\t', index=False)

# Save the essential genes to a txt file for further analysis
hi_merged.gene.to_csv('output/deg/hi_essential_genes.txt', sep='\n', index = False)
pa_merged.gene.to_csv('output/deg/pa_essential_genes.txt', sep='\n', index = False)
sa_mrsa_merged.gene.to_csv('output/deg/sa_mrsa_essential_genes.txt', sep='\n', index = False)