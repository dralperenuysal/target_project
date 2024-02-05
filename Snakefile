rule all:
    input:
        expand("output/barrnap/{genome}_rrna_count.gff", genome = ["hi", "pa", "sa_mrsa"])

rule barrnap:
    input:
        genome = "resource/genome/{genome}_genome.fasta"
    output:
        barrnap_gff = "output/barrnap/{genome}_rrna_count.gff"

    conda: "env/env.yaml"

    shell:
        """barrnap --kingdom bac --quiet {input.genome} > {output.barrnap_gff}"""