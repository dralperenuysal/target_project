# Define the paths
path_hi = "output/eggnog/hi_eggnog.emapper.annotations"
path_pa = "output/eggnog/pa_eggnog.emapper.annotations"
path_sa_mrsa = "output/eggnog/sa_mrsa_eggnog.emapper.annotations"

# Define the function to read dataframes
def eggnog_filtration(path):
    import pandas as pd
    df = pd.read_csv(path, sep="\t", header='infer', skiprows=3)
    df = df[:-3]
    df = df[['#query_name', 'seed_ortholog_score', 'best_tax_level', 'Preferred_name', 'COG Functional cat.', 'eggNOG free text desc.']]
    return df

hi = eggnog_filtration(path_hi)
pa = eggnog_filtration(path_pa)
sa_mrsa = eggnog_filtration(path_sa_mrsa)

hi.dropna(subset= ['Preferred_name'], inplace= True)
pa.dropna(subset= ['Preferred_name'], inplace= True)
sa_mrsa.dropna(subset= ['Preferred_name'], inplace= True)

hi['Preferred_name'].to_csv("output/eggnog/hi_eggnog.txt", sep = '\n', index = False, header = False)
pa['Preferred_name'].to_csv("output/eggnog/pa_eggnog.txt", sep = '\n', index = False, header = False)
sa_mrsa['Preferred_name'].to_csv("output/eggnog/sa_mrsa_eggnog.txt", sep = '\n', index = False, header = False)

df = pd.read_csv("output/eggnog/hi_eggnog.emapper.annotations", sep = '\t', header = 'infer', skiprows = 3)