library(readr)

# Define the file path
hi_masked <- "output/repeatmasker/hi_masked/hi_genome.fasta.out"
pa_masked <- "output/repeatmasker/pa_masked/pa_genome.fasta.out"
sa_mrsa_masked <- "output/repeatmasker/sa_mrsa_masked/sa_mrsa_genome.fasta.out"
col_names <- c('SW_score', 'perc_div', 'perc_del', 'perc_ins', 'query_sequence', 'begin', 'end', 'left', 'plus', 'repeat', 'class_family', 'repeat_begin', 'repeat_end', 'repeat_left', 'ID')

# Read the data
hi <- read.table(hi_masked, skip = 3, col.names = col_names, header = FALSE)
pa <- read.table(hi_masked, skip = 3, col.names = col_names, header = FALSE)
sa_mrsa <- read.table(hi_masked, skip = 3, col.names = col_names, header = FALSE)

# Save the data as csv for further analysis in Python
write.csv(hi, file = "output/repeatmasker/hi_masked/hi_genome.fasta.out.csv")
write.csv(pa, file= "output/repeatmasker/pa_masked/pa_genome.fasta.out.csv")
write.csv(sa_mrsa, file= "output/repeatmasker/sa_mrsa_masked/sa_mrsa_genome.fasta.out.csv")