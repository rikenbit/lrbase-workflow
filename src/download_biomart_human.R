source("src/functions.R")

# biomaRt
db <- useMart("ensembl")
ds <- useDataset("hsapiens_gene_ensembl", mart=db)

res <- getBM(
	attributes=c("ensembl_gene_id",
		"entrezgene_id"),
	mart = ds)

# Ouput
write.csv(res, "data/biomart/9606.csv",
	quote=FALSE, row.names=FALSE)
