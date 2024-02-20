import pandas as pd
from upsetplot import UpSet
import seaborn as sns
import matplotlib.pyplot as plt

orthogroups = 'output/orthofinder/Results_Feb17/Orthogroups/Orthogroups.tsv'
gene_count = 'output/orthofinder/Results_Feb17/Orthogroups/Orthogroups.GeneCount.tsv'
singletone = 'output/orthofinder/Results_Feb17/Orthogroups/Orthogroups_UnassignedGenes.tsv'

# Read the orthogroup data
ortho = pd.read_csv(orthogroups, sep='\t', header='infer')
ortho.dropna(inplace=True) # Drop nan values of orthogroups

# Read the gene count
ortho_gene_count = pd.read_csv(gene_count, sep='\t', header='infer')
ortho_gene_count.loc[ortho_gene_count["Total"] > 1, "Type"] = "OG" # if total is greater than 1, write "OG"

# Read the singletone
sing = pd.read_csv(singletone, sep='\t', header='infer')
sing.fillna(0, inplace=True) # Fill the blank values with 0
sing['Total'] = 1 # Create new column and write 1
sing = sing.map(lambda x: 1 if isinstance(x, str) == True else x) # Change the str data to 1

# Concat the dataframes
gene_count_s = pd.concat([ortho_gene_count, sing], axis =0)
gene_count_s.loc[gene_count_s["Total"] > 1, "Type"] = "OG"
gene_count_s.loc[gene_count_s["Total"] == 1, "Type"] = "singleton"

df_stack = gene_count_s.set_index(gene_count_s["hi_protein"] >=1). \
    set_index(gene_count_s["pa_protein"] >=1, append = True). \
    set_index(gene_count_s["sa_mrsa_protein"] >= 1, append = True)

upset0 = UpSet(df_stack.sort_values(by = "Total", ascending=True),
               min_subset_size=10,
               intersection_plot_elements=0,
               show_counts=True)

pal = sns.dark_palette("#69d", n_colors=2, reverse=False)
upset0.add_stacked_bars(by = "Type",
                        colors=pal,
                        title="Count by type",
                        elements=5)

upset0.style_subsets(max_degree=1,
                     facecolor="white",
                     edgecolor="black",
                     label="Species-specific")

sns.set_style("whitegrid", {"axes.grid": False})
upset0.plot()
plt.suptitle("OG Upset plot")
# plt.savefig(out_0, format="png", dpi=1200, bbox_inches="tight")
plt.show()