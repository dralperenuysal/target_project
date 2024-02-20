import pandas as pd
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Define the paths
main_path = "output/eggnog"
path_hi = "output/eggnog/hi_eggnog.emapper.annotations"
path_pa = "output/eggnog/pa_eggnog.emapper.annotations"
path_sa_mrsa = "output/eggnog/sa_mrsa_eggnog.emapper.annotations"

# Define the function to read and manipulate the dataframes
def eggnog_filtration(path, main_path, prefix):
    import pandas as pd
    df = pd.read_csv(path, sep="\t", header='infer', skiprows=3)
    df = df[:-3]
    df = df[['#query_name', 'seed_ortholog_score', 'best_tax_level', 'Preferred_name', 'COG Functional cat.', 'eggNOG free text desc.']]
    df = df.rename(columns= {'Preferred_name': 'name',
                             'COG Functional cat.': 'cog',
                             'eggNOG free text desc.': 'description'})
    df.dropna(subset= ['cog', 'name'] ,inplace=True)
    df.name.to_csv(f"{main_path}/{prefix}_eggnog.txt", sep='\n', index=False, header=False)
    return df

hi = eggnog_filtration(path_hi, main_path, "hi")
pa = eggnog_filtration(path_pa, main_path, "pa")
sa_mrsa = eggnog_filtration(path_sa_mrsa, main_path, "sa_mrsa")

### -------------- CREATE THE REPRODUCIBLE GRAPHIC MAKER -----------------
def plot_categories(hi, column_name='cog', organism = "Bacteria"):
    hi_cog = pd.DataFrame(hi[column_name].value_counts()[:15]).reset_index()
    hi_cog.columns = ['COG Functional Category', 'count']

    fig, ax = plt.subplots(figsize=(16, 9))
    ax.set_xlabel('COG Functional Category', fontsize=15)
    ax.set_ylabel('Count', fontsize=15)
    plt.title(f"{organism} - COG Functional Category", fontsize=20)

    # sns.barplot kullanarak barplot çizdirme ve değerleri ekleyin
    barplot = sns.barplot(data=hi_cog, x='COG Functional Category', y='count', palette='flare')

    # Barların üzerine değerleri ekleyin
    for index, row in hi_cog.iterrows():
        barplot.text(index, row['count'], round(row['count'], 2), color='black', ha="center", fontsize=15)

    # Eksen değerlerinin daha okunabilir olmasını sağlayın
    plt.xticks(fontsize=15)
    plt.yticks(fontsize=15)

    plt.tight_layout()  # Grafiğin düzgün sığdırılması için
    plt.show()

### -------------- PLOT THE COG DATA -----------------

plot_categories(hi, column_name='cog', organism="H. influenzae")
plot_categories(pa, column_name='cog', organism="P. aeuruginosa")
plot_categories(sa_mrsa, column_name='cog', organism="MRSA")

### -------------- COG CATEGORIEs ---------------------

hicog = pd.DataFrame(hi.cog.value_counts())
pacog = pd.DataFrame(pa.cog.value_counts())
sa_mrsacog = pd.DataFrame(sa_mrsa.cog.value_counts())

hi['organism'] = "H. influenzae"
pa['organism'] = "P. aeuruginosa"
sa_mrsa['organism'] = "MRSA"
concat = pd.concat([hi, pa, sa_mrsa], axis=0)
COG_counts = concat.groupby(['cog', 'organism']).size().unstack()
COG_counts_sorted = COG_counts.sort_values(by = 'P. aeuruginosa', ascending=False)[:15]

COG_counts_sorted.plot(kind='bar')
plt.xlabel('COG')
plt.ylabel('Count')
plt.title('COG Catergory Distrubition among the organisms')
plt.legend()
plt.xticks(rotation = 1, ha= 'right', fontsize=11)
plt.tight_layout()  # Adjust layout to prevent crowding
plt.show()