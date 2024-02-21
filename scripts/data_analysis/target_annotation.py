import pandas as pd

# Define the paths
target_path = "output/essentials_intersection_targets.tsv"
hi_annotation = "output/deg/hi_annotated.tsv"
pa_annotation = "output/deg/pa_annotated.tsv"
sa_mrsa_annotation = "output/deg/sa_mrsa_annotated.tsv"

# Read all data
targets = pd.read_csv(target_path, sep="\t", index_col=0, header='infer')
hi_ann = pd.read_csv(hi_annotation, sep="\t", index_col=0, header= 'infer')
pa_ann = pd.read_csv(pa_annotation, sep="\t", index_col=0, header= 'infer')
sa_mrsa_ann = pd.read_csv(sa_mrsa_annotation, sep="\t", index_col=0, header= 'infer')

# Merge the data to annotate the gene names
hi_target = pd.merge(targets, hi_ann, how='left', on=['gene'])
pa_target = pd.merge(targets, pa_ann, how='left', on=['gene'])
sa_mrsa_target = pd.merge(targets, sa_mrsa_ann, how='left', on=['gene'])

# Concat the organism annotations
targets_all = pd.concat([hi_target, pa_target, sa_mrsa_target], axis=0).reset_index().drop(columns=['index', 'involve'])

# Save the dataframe
targets_all.to_csv("output/target_annotation.tsv", sep='\t', index=False)