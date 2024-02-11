import pandas as pd

core_genes = pd.read_csv('output/pangenome/gene_presence_absence.csv', sep=',', header='infer')
filtered = core_genes.iloc[:, [0,14,15,16]]

annotation = pd.read_csv('output/prokka_annotation/hi_prokka/hi.gff', sep='\t', header=None)
