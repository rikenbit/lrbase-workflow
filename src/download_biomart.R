source("src/functions.R")

# Parameter
taxid <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

sample_sheet <- read.csv("sample_sheet/ensembl.csv", stringsAsFactor=FALSE)
dataset <- sample_sheet[which(sample_sheet['Taxon.ID'] == taxid),
	'Dataset.name']

human_table <- read.csv('data/biomart/9606.csv')
human_table <- human_table[which(!is.na(human_table[,2])), ]

# biomaRt
db <- useMart("ensembl")
check1 <- try(ds <- useDataset(dataset, mart=db))

check2 <- try(res1 <- getBM(
	attributes=c("ensembl_gene_id",
		"hsapiens_homolog_ensembl_gene"),
	mart = ds))

check3 <- try(res2 <- getBM(
		attributes=c("ensembl_gene_id",
			"entrezgene_id"),
		mart = ds))

if((class(check1) != "try-error")
	&&(class(check2) != "try-error")
		&&(class(check3) != "try-error")){
	res3 <- merge(res1, res2, by="ensembl_gene_id")
	res <- merge(res3, human_table,
		by.x="hsapiens_homolog_ensembl_gene",
		by.y="ensembl_gene_id")
	res <- res[complete.cases(res), c("entrezgene_id.x", "entrezgene_id.y")]
	colnames(res) <- c(paste0("GENEID_", taxid), "GENEID_9606")
	# Ouput
	write.csv(res, outfile, quote=FALSE, row.names=FALSE)
}else{
	file.create(outfile)
}