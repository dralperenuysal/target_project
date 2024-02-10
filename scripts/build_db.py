from snakemake.shell import shell

fasta = snakemake.input.fasta
out = snakemake.output.db

# Command runs in the right directory
shell(
    f"""
    BuildDatabase -name {out} -engine ncbi {fasta}
    """
)