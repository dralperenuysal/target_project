from snakemake.shell import shell

# Bring the information from Snakemake
fasta = snakemake.input.fasta
out = snakemake.output.out
log = snakemake.log

# Run the shell
shell(
    f"""
    quast.py {fasta} -o {out} &> {log}
    """
)