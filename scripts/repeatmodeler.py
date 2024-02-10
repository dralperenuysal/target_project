from snakemake.shell import shell

# Get the necessary variables from the snakefile
input = snakemake.input.db
out = snakemake.output.rm_output

# Define the parallel jobs number
num_parallel_jobs = 4

# Run the RepeatModeler dynamically.
shell(
    f"""
    RepeatModeler -database {input} -pa {num_parallel_jobs} > {out}
    """
)