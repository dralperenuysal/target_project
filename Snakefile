genomes = ["hi", "pa", "sa_mrsa"]
env= "env/env.yaml"

rule all:
    input:
        expand("output/barrnap/{genome}_rrna_count.gff", genome = genomes),
        expand("output/repeatmodeler/{genome}_rm", genome=genomes),
        expand("output/repeatmodeler/{genome}_rm/{genome}_db-families.fa", genome = genomes),
        expand("output/repeatmodeler/{genome}_rm/{genome}_db-families.stk", genome = genomes),
        #expand("output/repeatmasker/{genome}_genome.fasta.masked",genome=genomes),
        #expand("output/repeatmasker/{genome}_genome.fasta.out",genome=genomes),
        #expand("output/repeatmasker/{genome}_genome.fasta.tbl",genome=genomes),

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
        fasta = "resource/genome/{genome}_genome.fasta"
    output:
        db = directory("output/repeatmodeler/{genome}_rm")
    shell:
        """
        mkdir -p {output.db}
        cd {output.db}
        BuildDatabase -engine ncbi -name {wildcards.genome}_db ../../../{input.fasta}
        """

rule repeatmodeler:
    output:
        fa = "output/repeatmodeler/{genome}_rm/{genome}_db-families.fa",
        stk = "output/repeatmodeler/{genome}_rm/{genome}_db-families.stk"
    params:
        path = lambda wildcards: f"output/repeatmodeler/{wildcards.genome}_rm",
        db = lambda wildcards: f"{wildcards.genome}_db"
    shell:
        """
        cd {params.path}
        RepeatModeler -database {db} -engine ncbi -pa 20
        touch {output.fa}
        """








