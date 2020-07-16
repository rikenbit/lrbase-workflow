source("src/functions.R")

# Parameter
taxid <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

sample_sheet <- read.csv("ensembl_samples.csv", stringsAsFactor=FALSE)
dataset <- sample_sheet[which(sample_sheet['Taxon.ID'] == taxid),
	'Dataset.name']

human_table <- read.csv('data/biomart/9606.csv')
human_table <- human_table[which(!is.na(human_table[,2])), ]

# biomaRt
db <- useMart("ensembl")
ds <- useDataset(dataset, mart=db)

res1 <- getBM(
	attributes=c("ensembl_gene_id",
		"hsapiens_homolog_ensembl_gene"),
	mart = ds)

res2 <- getBM(
	attributes=c("ensembl_gene_id",
		"entrezgene_id"),
	mart = ds)

res3 <- merge(res1, res2, by="ensembl_gene_id")

res <- merge(res3, human_table,
	by.x="hsapiens_homolog_ensembl_gene",
	by.y="ensembl_gene_id")

res <- res[complete.cases(res), c("entrezgene_id.x", "entrezgene_id.y")]

colnames(res) <- c(paste0(taxid, "_GENEID"), "9606_GENEID")

# Ouput
write.csv(res, outfile, quote=FALSE, row.names=FALSE)
