import pandas as pd

emap = pd.read_csv("output/eggnog_web/sa_mrsa_eggnogweb/sa_mrsa_eggnogmapper.tsv", sep= '\t', header='infer')

emap = emap[emap['COG_category'] != "-"]
emap = emap.dropna(subset=['COG_category'])
emap = emap.drop(columns = ['evalue', 'score'])
