import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


gff_path = 'output/barrnap/sa_mrsa_rrna_count.gff'
gff_df = pd.read_csv(gff_path, sep='\t', comment='#', header=None,
                     names=['seqid', 'source', 'type', 'start', 'end', 'score', 'strand', 'phase', 'attributes'])

gff_df = gff_df.drop(columns=['strand', 'phase', 'seqid', 'source', 'type'])

gff_df['rRNA_type'] = gff_df['attributes'].apply(lambda x: x.split(';')[0].replace('Name=', '').split('_')[0])

gff_df['status'] = gff_df['attributes'].apply(lambda x: "Partial" if "partial" in x else "Not partial")

gff_df.drop(columns=['attributes', 'score'], inplace=True)

rRNA_types = gff_df.groupby('rRNA_type').size()
plt.pie(rRNA_types, labels=rRNA_types.index, autopct="%1.1f%%", startangle=90,
        colors=sns.color_palette("tab10"))
plt.title("rRNA frequency")
plt.xlabel("rRNA type")
plt.ylabel("Frequency")
plt.legend(title="rRNA types")

plt.show()