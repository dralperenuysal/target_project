from snakemake.shell import shell

# Define input and output paths directly
input_genome = snakemake.input.genome
masked = snakemake.output.masked
tbl = snakemake.output.tbl
out = snakemake.output.out

# Run RepeatMasker using full paths for input and output
shell(f"RepeatMasker -s -species bacteria -pa 4 -dir {masked.rsplit('/', 1)[0]} {input_genome}")