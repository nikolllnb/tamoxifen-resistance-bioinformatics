# Enrichment analysis and figure generation
# Tamoxifen resistance project

setwd("/home/nikolnb/tamoxifen_resistance_project")

library(AnnotationDbi)
library(GO.db)
library(org.Hs.eg.db)
library(pheatmap)

# Load differential-expression results
res <- read.csv("results/TR1_vs_Control_annotated.csv")

# Select significant genes using the thresholds from the analysis
sig <- res[!is.na(res$adj.P.Val) & res$adj.P.Val < 0.05, ]

up_genes <- unique(na.omit(
  sig$SYMBOL[sig$logFC >= 1]
))

down_genes <- unique(na.omit(
  sig$SYMBOL[sig$logFC <= -1]
))

# Save selected gene lists
write.csv(
  data.frame(SYMBOL = up_genes),
  "results/upregulated_genes.csv",
  row.names = FALSE
)

write.csv(
  data.frame(SYMBOL = down_genes),
  "results/downregulated_genes.csv",
  row.names = FALSE
)

message("Gene lists saved.")
message("Upregulated genes: ", length(up_genes))
message("Downregulated genes: ", length(down_genes))