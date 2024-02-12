# Genome annotations of the target genomes (H. influenzae, P. aeruginosa and MRSA were done using prokka package.

from snakemake.shell import shell

fasta = snakemake.input.fasta
#out = snakemake.output.out
out = snakemake.params.out
cpus = snakemake.params.cpus
log = snakemake.log[0]
prefix = snakemake.params.prefix
protein = snakemake.params.protein

shell(
    f"""
    prokka --outdir {out} --force --cpus {cpus} --prefix {prefix} --addgenes --addmrna --metagenome --proteins {protein} {fasta} &> {log}
    """
)