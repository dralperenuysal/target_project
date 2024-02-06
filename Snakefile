genomes = ["hi", "pa", "sa_mrsa"]
env = "env/env.yaml"

rule all:
    input:
        expand("output/barrnap/{genome}_rrna_count.gff", genome = genomes),
        expand("resource/genome/{genome}_genome.fasta.masked", genome = genomes),
        expand("resource/genome/{genome}_genome.fasta.out", genome = genomes),
        expand("resource/genome/{genome}_genome.fasta.tbl", genome = genomes),
        expand("output/repeatmodeler/{genome}_repeatmodeler_library.fa", genome=genomes)

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
        masked = "resource/genome/{genome}_genome.fasta.masked",
        tbl = "resource/genome/{genome}_genome.fasta.tbl",
        out = "resource/genome/{genome}_genome.fasta.out"
    conda: env
    shell:
        """RepeatMasker -s -species bacteria -pa 4 {input.genome}"""

rule repeatmodeler:
    input:
        "resource/genome/{genome}_genome.fasta"
    output:
        "output/repeatmodeler/{genome}_repeatmodeler_library.fa"
    conda:
        env
    shell:
        """
        BuildDatabase -name {wildcards.genome}_DB {input}
        RepeatModeler -database {wildcards.genome}_DB -engine ncbi -pa 4 -LTRStruct
        """

