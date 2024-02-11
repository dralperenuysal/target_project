# Pangenome analysis was done using rorary package.

from snakemake.shell import shell

annotations = snakemake.input
out = snakemake.output.out
cores = snakemake.threads
log = snakemake.log

shell(
    f"""
    roary -f {out} -e --mafft -cd 65 -i 70 -p {cores} {annotations} &> {log}
    """
)