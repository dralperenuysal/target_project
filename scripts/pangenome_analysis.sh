#!/bin/bash

# Run the roary
roary roary -f output/pangenome -e --mafft -cd 65 -i 70 -p 12 output/prokka_annotation/hi_prokka/hi.gff output/prokka_annotation/pa_prokka/pa.gff output/prokka_annotation/sa_mrsa_prokka/sa_mrsa.gff &> logs/pangenome/pangenome_manual.log