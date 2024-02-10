from snakemake.shell import shell

fasta = snakemake.input.fasta
db_name = snakemake.params.db_name
out = snakemake.output[0]

# Command runs in the right directory
shell(
    f"""
    mkdir -p {db_name}
    BuildDatabase -engine ncbi -name {db_name} {fasta}
    """
)