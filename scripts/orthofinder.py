from snakemake.shell import shell

proteomes = snakemake.input
threads = snakemake.threads
number_of_analysis = snakemake.params.numberofanalysis
out = snakemake.output


shell(
    f"""
    orthofinder -f {proteomes} -t {threads} -a {number_of_analysis} -og -o {out} 
    """
)