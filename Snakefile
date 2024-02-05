genomes = ["hi", "pa", "sa_mrsa"]

rule all:
    input:
        expand("output/barrnap/{genome}_rrna_count.gff", genome = genomes),
        expand("resource/genome/{genome}_genome.fasta.masked", genome = genomes),
        expand("resource/genome/{genome}_genome.fasta.out", genome = genomes),
        expand("resource/genome/{genome}_genome.fasta.tbl", genome = genomes)

rule barrnap:
    input:
        genome = "resource/genome/{genome}_genome.fasta"
    output:
        barrnap_gff = "output/barrnap/{genome}_rrna_count.gff"
    conda: "env/env.yaml"
    shell:
        """barrnap --kingdom bac --quiet {input.genome} > {output.barrnap_gff}"""

rule repeatmasker:
    input:
        genome = "resource/genome/{genome}_genome.fasta"
    output:
        masked = "resource/genome/{genome}_genome.fasta.masked",
        tbl = "resource/genome/{genome}_genome.fasta.tbl",
        out = "resource/genome/{genome}_genome.fasta.out"
    conda: "env/env.yaml"
    shell:
        """RepeatMasker -s -species bacteria -pa 4 {input.genome}"""
