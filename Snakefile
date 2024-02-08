genomes = ["hi", "pa", "sa_mrsa"]
env= "env/env.yaml"

rule all:
    input:
        expand("output/barrnap/{genome}_rrna_count.gff", genome = genomes),
        expand("resource/repeatmasker/{genome}_genome.fasta.masked",genome=genomes),
        expand("resource/repeatmasker/{genome}_genome.fasta.out",genome=genomes),
        expand("resource/repeatmasker/{genome}_genome.fasta.tbl",genome=genomes),
        expand("resource/repeatmodeler/{genome}-families.fa",genome=genomes),
        expand("resource/repeatmodeler/{genome}-families.stk",genome=genomes),
        expand("resource/repeatmodeler/{genome}-rmod.log",genome=genomes)


rule barrnap:
    input:
        genome = "resource/genome/{genome}_genome.fasta"
    output:
        barrnap_gff = "output/barrnap/{genome}_rrna_count.gff"
    conda: env
    shell:
        """barrnap --kingdom bac --quiet {input.genome} > {output.barrnap_gff}"""

rule repeatmasker:
    input:
        genome = "resource/genome/{genome}_genome.fasta"
    output:
        masked = "resource/repeatmasker/{genome}_genome.fasta.masked",
        tbl = "resource/repeatmasker/{genome}_genome.fasta.tbl",
        out = "resource/repeatmasker/{genome}_genome.fasta.out"
    threads: 4
    script:
        "scripts/repeatmasker.py"

rule repeatmodeler:
    input:
        fasta= "resource/genome/{genome}_genome.fasta"
    output:
        families_fa = "resource/repeatmodeler/{genome}-families.fa",
        families_stk = "resource/repeatmodeler/{genome}-families.stk",
        rmod_log = "resource/repeatmodeler/{genome}-rmod.log"
    params:
        database_name = "{genome}",
        threads = 20, # Adjust the number of threads based on your system
        recoverDir = "" # Leave empty if not recovering, or specify the directory to recover from
    script:
        "scripts/repeatmodeler.py"