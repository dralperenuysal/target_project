import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from glob import glob

def process_gff(gff_path):
    # Read the *.gff
    gff_df = pd.read_csv(gff_path, sep='\t', comment='#', header=None,
                         names=['seqid', 'source', 'type', 'start', 'end', 'score', 'strand', 'phase', 'attributes'])

    # rRNA type and status
    gff_df['rRNA_type'] = gff_df['attributes'].apply(lambda x: x.split(';')[0].replace('Name=', '').split('_')[0])
    gff_df['status'] = gff_df['attributes'].apply(lambda x: "Partial" if "partial" in x else "Not partial")

    # Get the charted parts
    gff_df = gff_df[['start', 'end', 'rRNA_type', 'status']]

    return gff_df
def rRNA_pie(gff_df, save_path, organism = "organism"):

    # Count the rRNA types and visualize as pie chart
    rRNA_types = gff_df.groupby('rRNA_type').size()
    plt.figure(figsize=(8, 6))
    plt.pie(rRNA_types, labels=rRNA_types.index, autopct="%1.1f%%", startangle=90,
            colors=sns.color_palette("tab10"))
    plt.title(f"{organism} rRNA Frequency")
    plt.legend(title="rRNA Types", bbox_to_anchor=(1.05, 1), loc='upper left')

    # Grafiği belirtilen dosya yoluna kaydet
    plt.savefig(save_path)
    plt.close()

# Liste the *.gff files with glob and assign the variables
gff_files = glob("output/barrnap/*")
save_dir = "output/plots/barrnap/"
save = [f"{save_dir}hi_barrnap_chart.png", f"{save_dir}pa_barrnap_chart.png", f"{save_dir}sa_mrsa_barrnap_chart.png"]
organism = ["Haemophilus influenzae", "Pseudomonas aeruginosa", "Staphylococcus aureus"]

# Create the pie charts with a for loop
for i in range(0,3):
    rRNA_pie(gff_df= process_gff(gff_files[i]), save_path = save[i], organism = organism[i])

# Read the data seperately
hi_gff = process_gff(gff_files[0])
pa_gff = process_gff(gff_files[1])
sa_mrsa_gff = process_gff(gff_files[2])

# Add the organism names
hi_gff['organism'] = organism[0]
pa_gff['organism'] = organism[1]
sa_mrsa_gff['organism'] = organism[2]

# Concatenate the barrnap results
concatenated_gff = pd.concat([hi_gff, pa_gff, sa_mrsa_gff], ignore_index=True, axis= 0)

# Plotting
# Plot the rRNA type in each organism in one graph
rRNA_counts = concatenated_gff.groupby(['organism', 'rRNA_type']).size().unstack()
rRNA_counts.plot(kind='bar')
plt.xlabel('Organism')
plt.ylabel('Count of rRNA Types')
plt.title('Distribution of rRNA Types in Organisms')
plt.legend()
plt.xticks(rotation=45, ha='right')  # Rotate x-axis labels for readability
plt.tight_layout()  # Adjust layout to prevent crowding
plt.savefig("output/plots/barrnap/rrNA_counts.png")

# Plot the partiality status of the rrNAs in each organism
plt.figure()
sns.countplot(data = concatenated_gff, x='organism', hue='status', palette='Set2')
plt.xlabel('Organism')
plt.ylabel('Count of status')
plt.title('Distribution of Status')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig("output/plots/barrnap/rrNA_status.png")