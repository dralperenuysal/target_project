library(readr)
library(dplyr)

genes <- read.csv("output/pangenome/gene_presence_absence.csv", header = TRUE)

filtered <- genes %>%
  select(c(1,15,16, 17)) %>%
  na.omit()