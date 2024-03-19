library(dplyr)
library(readr)

# Read the targets
targets <- read_tsv("data/potential_targets/potential_targets.tsv")

# Define the organism abbrevations
hi <- "Haemophilus influenzae (strain ATCC 51907 / DSM 11121 / KW20 / Rd)"
pa <- "Pseudomonas aeruginosa (strain ATCC 15692 / DSM 22644 / CIP 104116 / JCM 14847 / LMG 12228 / 1C / PRS 101 / PAO1)"
mrsa <- "Staphylococcus aureus (strain MRSA252)"

# Tidy the metadata
targets <- targets %>%
  filter(Organism %in% c(hi, pa, mrsa)) %>%
  mutate(organism_code = case_when(
    grepl("Haemophilus", Organism) ~ "hi",
    grepl("Pseudomonas", Organism) ~ "pa",
    grepl("Staphylococcus", Organism) ~ "mrsa",
    TRUE ~ NA_character_
  ))

# Use a for loop to keep necessary protein files
for(code in c("hi", "pa", "mrsa")) {
  entries <- targets %>%
    filter(organism_code == code) %>%
    pull(Entry)

  # Dosya yolu örneği: "resource/potential_targets/hi"
  # Gerçek kullanımınızda klasör yapısına dikkat edin
  files <- list.files(paste0("resource/potential_targets/", code), full.names = TRUE)

  for(file in files) {
    accession_number <- sub("AF-(.*)-F1-model_v4.*", "\\1", basename(file))

    # Eğer dosya .cif.gz ile bitiyorsa veya accession number entries listesinde yoksa sil
    if(grepl("\\.cif\\.gz$", file) || !accession_number %in% entries) {
      file.remove(file)
    }
  }
}
