genomes = ["hi", "pa", "sa_mrsa"]
env= "env/env.yaml"

rule all:
    input:
        expand("output/barrnap/{genome}_rrna_count.gff", genome = genomes),
        expand("output/repeatmasker/{genome}_genome.fasta.masked",genome=genomes),
        expand("output/repeatmasker/{genome}_genome.fasta.out",genome=genomes),
        expand("output/repeatmasker/{genome}_genome.fasta.tbl",genome=genomes),
        expand("output/repeatmodeler/{genome}-families.fa",genome=genomes),
        expand("output/repeatmodeler/{genome}-families.stk",genome=genomes),
        expand("output/repeatmodeler/{genome}-rmod.log",genome=genomes)


rule barrnap:
    input:
        genome = "resource/genome/{genome}_genome.fasta"
    output:
        barrnap_gff = "output/barrnap/{genome}_rrna_count.gff"
    conda: env
    shell:
        """barrnap --kingdom bac --quiet {input.genome} > {output.barrnap_gff}"""

rule builddatabase:
    input:
        genome = "resource/genome/{genome}_genome.fasta"
    output: directory("resource/rm_db")
    params:
        db_name = "{genome}_db"
    script:
        "scripts/build_db.py"

rule repeatmasker:
    input:
        genome = "resource/genome/{genome}_genome.fasta"
    output:
        masked = "output/repeatmasker/{genome}_genome.fasta.masked",
        tbl = "output/repeatmasker/{genome}_genome.fasta.tbl",
        out = "output/repeatmasker/{genome}_genome.fasta.out"
    threads: 4
    script:
        "scripts/repeatmasker.py"

rule repeatmodeler:
    input:
        fasta= "resource/genome/{genome}_genome.fasta"
    output:
        families_fa = "output/repeatmodeler/{genome}-families.fa",
        families_stk = "output/repeatmodeler/{genome}-families.stk",
        rmod_log = "output/repeatmodeler/{genome}-rmod.log"
    params:
        database_name = "{genome}",
        threads = 20, # Adjust the number of threads based on your system
        recoverDir = "" # Leave empty if not recovering, or specify the directory to recover from
    script:
        "scripts/repeatmodeler.py"