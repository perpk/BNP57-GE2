install.packages("UpSetR")
library(UpSetR)
library(tidyverse)

enriched_down <- list.files(path = "./", pattern="*underexpressed*") %>% map_df(~read_tsv(.) %>% mutate(annotation_id = as.character(annotation_id)))
enriched_down_stat_sign <- enriched_down[enriched_down$pval_adj < 0.05, ]
enriched_down_cat_filter <- dplyr::filter(enriched_down_stat_sign, grepl("heart|vessel|tissue|card|pulm|hyper", description))

annotation_vs_gene_under <- select(enriched_down_cat_filter, description, genes)

gene_sets_under <- setNames(lapply(strsplit(annotation_vs_gene_under$genes, ","), unique), annotation_vs_gene_under$description)
upset(fromList(gene_sets_under), order.by="freq")

enriched_up <- list.files(path = "./", pattern="*overexpressed*") %>% map_df(~read_tsv(.) %>% mutate(annotation_id = as.character(annotation_id)))
enriched_up_stat_sign <- enriched_up[enriched_up$pval_adj < 0.05, ]
enriched_up_cat_filter <- dplyr::filter(enriched_up_stat_sign, grepl("heart|vessel|tissue|card|pulm", description))

annotation_vs_gene_over <- select(enriched_up_stat_sign, description, genes)
gene_sets_under <- setNames(lapply(strsplit(annotation_vs_gene_over$genes, ","), unique), annotation_vs_gene_over$description)
upset(fromList(gene_sets_under), order.by="freq")


# Create edges
edges <- do.call(rbind, lapply(1:nrow(annotation_vs_gene_under), function(i) {
  data.frame(
    Description = annotation_vs_gene_under$description[i],
    Gene = unlist(strsplit(annotation_vs_gene_under$genes[i], ","))
  )
}))

install.packages("networkD3")
library(networkD3)

simpleNetwork(edges[edges$Description == "Abnormal myocardium morphology",], 
              zoom=TRUE, linkDistance=200, opacity = 100, fontSize=12)

simpleNetwork(edges[edges$Description == "Dilated cardiomyopathy",], 
              zoom=TRUE, linkDistance=200, opacity = 100, fontSize=12)

View(edges)
