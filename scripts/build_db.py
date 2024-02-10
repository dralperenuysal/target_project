from snakemake.shell import shell

fasta = snakemake.input.genome
output = snakemake.output[0]
db_name = snakemake.params.db_name

shell(f"""
cd resource/rm_db
BuildDatabase -name {db_name} -engine ncbi {fasta}
""")