#!/bin/bash

# Check and create the output directory if it does not exist
mkdir -p output/eggnog

# Run EggNOG-mapper for Hi protein fasta
emapper.py -i resource/protein/hi_protein.fasta --output_dir output/eggnog -o hi_eggnog --database bact --predict_ortho -m diamond --cpu 20

# Run EggNOG-mapper for Pa protein fasta
emapper.py -i resource/protein/pa_protein.fasta --output_dir output/eggnog -o pa_eggnog --database bact --predict_ortho -m diamond --cpu 20

# Run EggNOG-mapper for SA MRSA protein fasta
emapper.py -i resource/protein/sa_mrsa_protein.fasta --output_dir output/eggnog -o sa_mrsa_eggnog --database bact --predict_ortho -m diamond --cpu 20
