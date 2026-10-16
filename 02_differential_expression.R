# Differential expression: TR1 vs parental controls

library(limma)
library(AnnotationDbi)
library(hgu133plus2.db)
library(affy)

setwd("/home/nikolnb/tamoxifen_resistance_project")

# Load normalised expression data
eset_rma <- readRDS("data/eset_rma.rds")
expression_matrix <- exprs(eset_rma)

# Verify sample order
samples <- colnames(expression_matrix)
stopifnot(
  all(grepl("Ctrl", samples[1:3])),
  all(grepl("TR1", samples[4:6]))
)

# Compare the three TR1 samples with three controls
group <- factor(c(
  "Control", "Control", "Control",
  "TR1", "TR1", "TR1"
))
design <- model.matrix(~ 0 + group)
colnames(design) <- levels(group)

fit <- lmFit(expression_matrix[, 1:6], design)
contrast <- makeContrasts(TR1 - Control, levels = design)
fit <- contrasts.fit(fit, contrast)
fit <- eBayes(fit)

# Export probe-level results
de_results <- topTable(fit, number = Inf, sort.by = "P")
de_results$ProbeID <- rownames(de_results)

write.csv(
  de_results,
  "results/TR1_vs_Control_all_probes.csv",
  row.names = FALSE
)

# Annotate probes with gene symbols and names
annotation <- AnnotationDbi::select(
  hgu133plus2.db,
  keys = unique(de_results$ProbeID),
  columns = c("SYMBOL", "GENENAME"),
  keytype = "PROBEID"
)
annotation <- annotation[!duplicated(annotation$PROBEID), ]

annotated_results <- merge(
  de_results, annotation,
  by.x = "ProbeID", by.y = "PROBEID",
  all.x = TRUE, sort = FALSE
)

write.csv(
  annotated_results,
  "results/TR1_vs_Control_annotated.csv",
  row.names = FALSE
)

message("Differential-expression analysis completed.")