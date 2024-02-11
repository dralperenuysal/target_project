genomes = ["hi", "pa", "sa_mrsa"]
env= "env/env.yaml"

rule all:
    input:
        # barrnap output
        expand("output/barrnap/{genome}_rrna_count.gff", genome = genomes),

        # Database building for RepeatModeler and RepeatMasker
        expand("output/repeatmodeler/{genome}_rm/{genome}_db.nhr", genome = genomes),
        expand("output/repeatmodeler/{genome}_rm/{genome}_db.nin", genome = genomes),
        expand("output/repeatmodeler/{genome}_rm/{genome}_db.nnd", genome = genomes),
        expand("output/repeatmodeler/{genome}_rm/{genome}_db.nni", genome = genomes),
        expand("output/repeatmodeler/{genome}_rm/{genome}_db.nog", genome = genomes),
        expand("output/repeatmodeler/{genome}_rm/{genome}_db.nsq", genome = genomes),

        # RepeatModeler outputs
        expand("output/repeatmodeler/{genome}_rm/{genome}_db-families.fa", genome = genomes),
        expand("output/repeatmodeler/{genome}_rm/{genome}_db-families.stk", genome = genomes),

        # RepeatMasker output
        expand("output/repeatmasker/{genome}_masked/{genome}_genome.fasta.masked", genome = genomes),
        expand("output/repeatmasker/{genome}_masked/{genome}_genome.fasta.out", genome = genomes),
        expand("output/repeatmasker/{genome}_masked/{genome}_genome.fasta.tbl", genome = genomes),

        # Quality Control with quast
        expand("output/quast/{genome}_quality", genome = genomes),

        # Annotation of the target genomes using prokka
        expand("output/prokka_annotation/{genome}_prokka/{genome}.gff", genome = genomes),

        # Pan-genome analysis using roary
        "output/pangenome"

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
        nhr = "output/repeatmodeler/{genome}_rm/{genome}_db.nhr",
        nin = "output/repeatmodeler/{genome}_rm/{genome}_db.nin",
        nnd = "output/repeatmodeler/{genome}_rm/{genome}_db.nnd",
        nni = "output/repeatmodeler/{genome}_rm/{genome}_db.nni",
        nog = "output/repeatmodeler/{genome}_rm/{genome}_db.nog",
        nsq = "output/repeatmodeler/{genome}_rm/{genome}_db.nsq"
    params:
        db_path = "output/repeatmodeler/{genome}_rm"
    shell:
        """
        mkdir -p {params.db_path}
        cd {params.db_path}
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
        RepeatModeler -database {params.db} -engine ncbi -pa 20
        """

rule repeatmasker:
    input:
        fasta = lambda wildcards: f"resource/genome/{wildcards.genome}_genome.fasta"
    output:
        masked = "output/repeatmasker/{genome}_masked/{genome}_genome.fasta.masked",
        out = "output/repeatmasker/{genome}_masked/{genome}_genome.fasta.out",
        tbl = "output/repeatmasker/{genome}_masked/{genome}_genome.fasta.tbl"
    params:
        dir = lambda wildcards: f"output/repeatmasker/{wildcards.genome}_masked",
        lib = rules.repeatmodeler.output.fa,
    # conda: env
    script: "scripts/repeatmasker.py"

rule quality_control:
    input:
        fasta = lambda wildcards: f"resource/genome/{wildcards.genome}_genome.fasta"
    output:
        out = directory("output/quast/{genome}_quality")
    log:
        "logs/quast/{genome}_quality.log"
    conda: env
    script:
        "scripts/quality_control.py"

rule genome_annotation:
    input:
        fasta = lambda wildcards: f"resource/genome/{wildcards.genome}_genome.fasta"
    output:
        gff = "output/prokka_annotation/{genome}_prokka/{genome}.gff"
    conda: env
    params:
        out = "output/prokka_annotation/{genome}_prokka",
        cpus = 12,
        prefix = lambda wildcards: f"{wildcards.genome}"
    log:
        "logs/prokka/{genome}_prokka.log"
    script:
        "scripts/genome_annotation.py"

rule pangenome_analysis:
    input:
        expand("output/prokka_annotation/{genome}_prokka/{genome}.gff", genome = genomes),
    output:
        out = directory("output/pangenome")
    conda: "env/roary.yaml"
    threads: 12
    log:
        "logs/pangenome/pangenome.log"
    script:
        "scripts/pangenome_analysis.py"

