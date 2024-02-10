genomes = ["hi", "pa", "sa_mrsa"]
env= "env/env.yaml"

rule all:
    input:
        expand("output/barrnap/{genome}_rrna_count.gff", genome = genomes),
        expand("resource/rm_db/{genome}_db", genome = genomes),
        expand("output/repeatmodeler/{genome}_rm", genome = genomes),
        #expand("output/repeatmasker/{genome}_genome.fasta.masked",genome=genomes),
        #expand("output/repeatmasker/{genome}_genome.fasta.out",genome=genomes),
        #expand("output/repeatmasker/{genome}_genome.fasta.tbl",genome=genomes),
        #expand("output/repeatmodeler/{genome}-families.fa",genome=genomes),
        #expand("output/repeatmodeler/{genome}-families.stk",genome=genomes),
        #expand("output/repeatmodeler/{genome}-rmod.log",genome=genomes)


rule barrnap:
    input:
        genome = "resource/genome/{genome}_genome.fasta"
    output:
        barrnap_gff = "output/barrnap/{genome}_rrna_count.gff"
    log: "logs/barrnap/{genome}_rna.log"
    conda: env
    shell:
        """(barrnap --kingdom bac --quiet {input.genome} > {output.barrnap_gff}) >{log} 2>&1"""

rule build_database:
    input:
        fasta = lambda wildcards: f"resource/genome/{wildcards.genome}_genome.fasta"
    output:
        db = directory("database/{genome}")
    #conda: env
    script:
        "scripts/build_db.py"

rule repeatmodeler:
    input:
        db = "database/{genome}.db"
    output:
        rm_output = "output/repeatmodeler/{genome}_rm"
    #conda: env
    script:
        "scripts/repeatmodeler.py"



