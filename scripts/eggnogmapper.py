from snakemake.shell import shell

protein = snakemake.input.protein
out = snakemake.params.out
cpu = snakemake.threads
database = snakemake.params.database

shell(
    f"""
    emapper.py -i {protein} --output_dir {out} --database {database} --predict_ortho -m diamond --cpu {cpu}
    """
)