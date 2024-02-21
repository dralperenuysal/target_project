import pandas as pd

def read_and_merge_data(target_file, annotations_files):
    """
    Reads target genes file and merges it with multiple annotation files.

    Parameters:
    - target_file: Path to the file containing target genes.
    - annotations_files: Dictionary of organism names and their corresponding annotation file paths.

    Returns:
    - A DataFrame containing annotated target genes for all provided organisms.
    """
    # Read target genes
    targets_df = pd.read_csv(target_file, sep="\t", header='infer')

    # Initialize an empty list to store annotated dataframes
    annotated_dfs = []

    # Loop through the annotation files and merge them with the target genes
    for organism, file_path in annotations_files.items():
        ann_df = pd.read_csv(file_path, sep="\t", header='infer')
        merged_df = pd.merge(targets_df, ann_df, how='left', on=['gene'])
        merged_df['organism'] = organism  # Add organism name as a column
        annotated_dfs.append(merged_df)

    # Combine annotations from all organisms
    all_targets_annotated = pd.concat(annotated_dfs, ignore_index=True).drop(columns=['involve'], errors='ignore')

    return all_targets_annotated

# Define file paths
target_path = "output/essentials_intersection_targets.tsv"
annotations_paths = {
    'hi': "output/deg/hi_annotated.tsv",
    'pa': "output/deg/pa_annotated.tsv",
    'sa_mrsa': "output/deg/sa_mrsa_annotated.tsv"
}

# Call the function with the specified files
all_targets_annotated = read_and_merge_data(target_path, annotations_paths)

# Save the combined annotated targets to a file
all_targets_annotated.to_csv("output/target_annotation.tsv", sep='\t', index=False)
