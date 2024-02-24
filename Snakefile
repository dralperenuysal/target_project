genomes = ["hi", "pa", "sa_mrsa"]
species = {
    "hi": "Haemophilus influenzae",
    "pa": "Pseudomonas aeruginosa",
    "sa_mrsa": "Staphylococcus aureus"
}
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
        expand("output/prokka_annotation/{genome}_prokka/{genome}.gbk", genome = genomes),

        # Pan-genome analysis using roary
        "output/pangenome", # Due to env activation issues roary analysis was done manually.

        # Eggnog-Mapper analysis was done with .sh file due to excessive database size.
        # directory("output/eggnog/")
        # Eggnog_mapper web tool was used to obtain proteome analysis.
        # directory("output/eggnog_web")

        # OrthoFinder outputs
        "output/orthofinder",

        # AntiSmash outputs
        expand("output/antismash/{genome}_antismash", genome = genomes)

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
        # BuildDatabase outputs were tested in a seperated env. Written below.
        nhr = "output/repeatmodeler/{genome}_rm/{genome}_db.nhr",
        nin = "output/repeatmodeler/{genome}_rm/{genome}_db.nin",
        nnd = "output/repeatmodeler/{genome}_rm/{genome}_db.nnd",
        nni = "output/repeatmodeler/{genome}_rm/{genome}_db.nni",
        nog = "output/repeatmodeler/{genome}_rm/{genome}_db.nog",
        nsq = "output/repeatmodeler/{genome}_rm/{genome}_db.nsq"
    params:
        db_path = "output/repeatmodeler/{genome}_rm" # To reach actual directory, this parameter was generated.
    shell:
        # Create if the target directory doesn't exist. Then with "cd" code, reach there.
        # Run the BuildDatabase.
        """
        mkdir -p {params.db_path} 
        cd {params.db_path}
        BuildDatabase -engine ncbi -name {wildcards.genome}_db ../../../{input.fasta}
        """

rule repeatmodeler:
    output:
        # .fa and .stk are the outputs of RepeatModeler.
        fa = "output/repeatmodeler/{genome}_rm/{genome}_db-families.fa",
        stk = "output/repeatmodeler/{genome}_rm/{genome}_db-families.stk"
    params:
        path = lambda wildcards: f"output/repeatmodeler/{wildcards.genome}_rm",
        db = lambda wildcards: f"{wildcards.genome}_db" # The database names were identified in the build_database rule. These names is used here as a parameter.

    # conda:
    # There is not conda argument here. RepeatModeler and RepeatMaker is not suitable to use in the remote environment.
    # That is why I created a new env and installed all packages including RepeatMasker, RepeatModeler and Snakemake.

    shell:
        # Go to the RepeatModeler path which is the same with the BuildDatabase.
        # Run the RepeatModeler.
        """
        cd {params.path}
        RepeatModeler -database {params.db} -engine ncbi -pa 8
        """

rule repeatmasker:
    input:
        fasta = lambda wildcards: f"resource/genome/{wildcards.genome}_genome.fasta"
    output:
        # The three filetypes below are the outputs of the RepeatMasker.
        masked = "output/repeatmasker/{genome}_masked/{genome}_genome.fasta.masked",
        out = "output/repeatmasker/{genome}_masked/{genome}_genome.fasta.out",
        tbl = "output/repeatmasker/{genome}_masked/{genome}_genome.fasta.tbl"
    params:
        dir = lambda wildcards: f"output/repeatmasker/{wildcards.genome}_masked",
        lib = rules.repeatmodeler.output.fa, # RepeatMasker uses the output of RepeatModeler as the library. I pulled this parameters direcly from the rule RepeatMasker.

    # conda:
    # The same issue with RepeatModeler. Read it.

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
    # For genome annotation, prokka was used.
    input:
        fasta = lambda wildcards: f"resource/genome/{wildcards.genome}_genome.fasta"
    output:
        # Only the files will be used for further analysis were defined as outputs.
        gff = "output/prokka_annotation/{genome}_prokka/{genome}.gff",
        gbk = "output/prokka_annotation/{genome}_prokka/{genome}.gbk"
    conda: env
    params:
        out = "output/prokka_annotation/{genome}_prokka",
        cpus = 12,
        prefix = lambda wildcards: f"{wildcards.genome}",
        protein = lambda wildcards: f"resource/protein/{wildcards.genome}_protein.fasta",

        # For genus and species use, I wrote a dict and used them in the code.
        genus = lambda wildcards: species[wildcards.genome].split(" ")[0],
        species = lambda wildcards: species[wildcards.genome].split(" ")[1]
    log:
        "logs/prokka/{genome}_prokka.log"
    script:
        "scripts/genome_annotation.py"

rule pangenome_analysis:
    # Pangenome analysis was done using "roary".
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

rule orthofinder:
    input:
        "resource/protein"
    output:
        directory("output/orthofinder")
    threads: 8
    params:
        numberofanalysis = 2
    conda: env
    log:
        "logs/orthofinder/orthofinder.log"
    script:
        "scripts/orthofinder.py"

rule antismash:
    # AntiSMASH was used to analyze seconday metabolites.
    input: rules.genome_annotation.output.gbk, # Prokka annotation file is the inpput of AntiSMASH.
    output: directory("output/antismash/{genome}_antismash"),
    threads: 8,
    params:
        taxon = "bacteria",
        genome = lambda wildcards: f"{wildcards.genome}",
    conda: env,
    log: "logs/antismash/{genome}_antismash.log",
    script:
        "scripts/antismash.py"