from snakemake.shell import shell

# Get paths directly from snakemake object
input_fasta = snakemake.input.fasta
families_fa = snakemake.output.families_fa
families_stk = snakemake.output.families_stk
database_name = snakemake.params.database_name
threads = snakemake.params.threads
recoverDir_option = f"-recoverDir {snakemake.params.recoverDir}" if snakemake.params.recoverDir else ""

# Assuming BuildDatabase and RepeatModeler write outputs to the current working directory,
# predefine output directory based on one of the outputs
output_dir = families_fa.rsplit('/', 1)[0]

# Run commands using full paths without changing the working directory
shell(f"BuildDatabase -name {database_name} {input_fasta} 2> build_database.log && "
      f"RepeatModeler -database {database_name} -pa {threads} {recoverDir_option} > repeatmodeler.log 2>&1 && "
      f"mv ./BuildDatabase/{database_name}.fa {families_fa} && "
      f"mv ./BuildDatabase/{database_name}.stk {families_stk}")

