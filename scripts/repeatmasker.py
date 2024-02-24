from snakemake.shell import shell

# Define input and output paths directly
dir = snakemake.params.dir
lib = snakemake.params.lib
genome = snakemake.input.fasta

# Run RepeatMasker using full paths for input and output
shell(
    f"""
    mkdir -p {dir}
    RepeatMasker -engine ncbi -s -pa 8 -lib {lib} {genome} -dir {dir}
    """
)