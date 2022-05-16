library(tidyverse)

snapshots <- read_tsv("http://ftp.flybase.org/releases/FB2022_02/precomputed_files/genes/gene_snapshots_fb_2022_02.tsv.gz",skip = 4)
snapshots <- dplyr::rename(snapshots, gene_id = `##FBgn_ID`)


gene_summaries <- read_tsv("http://ftp.flybase.org/releases/FB2022_02/precomputed_files/genes/automated_gene_summaries.tsv.gz",skip = 1)
gene_summaries <- dplyr::rename(gene_summaries, gene_id = `#primary_FBgn`)

res0 <- inner_join(snapshots, gene_summaries, by="gene_id")


res %>%
  dplyr::select(GeneSymbol,gene_snapshot_text) %>%
  filter(gene_snapshot_text!="Contributions welcome.") %>%
  distinct() %>%
  write_csv("snapshots.csv", col_names = F)




