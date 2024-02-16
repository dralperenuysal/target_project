from snakemake.shell import shell

input = snakemake.input
taxon = snakemake.params.taxon
out = snakemake.output
cpu = snakemake.threads
genome = snakemake.params.genome

shell(
    f"""
    download-antismash-databases
    antismash --cpu {cpu} --fullhmmer --asf --pfam2go --output-dir {out} {input}
    """
)