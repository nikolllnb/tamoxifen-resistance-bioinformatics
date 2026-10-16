# Tamoxifen resistance bioinformatics project
# Step 1: Load and normalise Affymetrix microarray data

library(GEOquery)
library(affy)

setwd("/home/nikolnb/tamoxifen_resistance_project")

cel_files <- list.files("data", pattern = "\\.CEL(\\.gz)?$",
                        full.names = TRUE, ignore.case = TRUE)

stopifnot(length(cel_files) == 9)

raw_data <- ReadAffy(filenames = cel_files)
eset_rma <- rma(raw_data)
saveRDS(eset_rma, "data/eset_rma.rds")
print(dim(exprs(eset_rma)))
