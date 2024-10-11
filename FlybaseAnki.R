library(tidyverse)

# creates anki deck in csv format per following spec
# https://docs.ankiweb.net/importing/text-files.html

snapshots <- read_tsv("https://ftp.flybase.net/releases/current/precomputed_files/genes/gene_snapshots_fb_2024_04.tsv.gz",skip = 4)
snapshots <- dplyr::rename(snapshots, gene_id = `##FBgn_ID`)


gene_summaries <- read_tsv("https://ftp.flybase.net/releases/current/precomputed_files/genes/automated_gene_summaries.tsv.gz",skip = 1)
gene_summaries <- dplyr::rename(gene_summaries, gene_id = `#primary_FBgn`)

res0 <- inner_join(snapshots, gene_summaries, by="gene_id")

res <- res0 |> dplyr::select(GeneSymbol,GeneID=gene_id,GeneName,Snapshot=gene_snapshot_text,Summary=summary_text) |>
  distinct()

# lots of genes of unknown function
res <- res |>
  filter(!str_detect(Snapshot,"Contributions welcome."))


# make header
h <- list(c(paste0("#columns:",paste(colnames(res),collapse=",")),
  "#deck:Flybase_2024_04",
  "#separator:Comma"))
names(h) <- colnames(res)[1]

bind_rows(res,as_tibble(h)) |> arrange(-str_detect(GeneSymbol,"^#")) |>
  write_csv("deck_with_headers.csv.gz", col_names = F)


write_csv(res,"deck_no_headers.csv.gz", col_names = F)



