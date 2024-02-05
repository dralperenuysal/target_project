rule all:
    input:
        "output/barrnap/{wildcard}_barrnap.gff"

rule barrnap:
    input:
        genome = "resource/{wildcard}/{genome}.fasta"
    output:
        barrnap_gff = "output/barrnap/{genome}_rrna_count.gff"

    conda: "env/env.yaml"

    shell:
        """barrnap --kingdom euk --quiet {input.genome} > {output.barrnap_gff}"""