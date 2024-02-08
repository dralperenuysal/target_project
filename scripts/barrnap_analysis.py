import pandas as pd
gff_path = 'output/barrnap/sa_mrsa_rrna_count.gff'
gff_df = pd.read_csv(gff_path, sep='\t', comment='#', header=None,
                     names=['seqid', 'source', 'type', 'start', 'end', 'score', 'strand', 'phase', 'attributes'])

print(gff_df)
