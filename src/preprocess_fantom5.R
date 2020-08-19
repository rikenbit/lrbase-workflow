# Data loading
fantom5 <- read.delim("data/fantom5/PairsLigRec.txt",  stringsAsFactor=FALSE, header=TRUE, sep="\t")
fantom5 <- fantom5[, c("Ligand.ApprovedSymbol", "Receptor.ApprovedSymbol", "PMID.Manual")]
fantom5 <- fantom5[intersect(which(fantom5[,1] != ""), which(fantom5[,2] != "")), ]

# No PMID
fantom5$PMID.Manual[which(fantom5$PMID.Manual == "")] <- "-"

#
# Emsembl（Gene ID - Symbol)
#
ensembl = read.delim("data/ensembl/9606_symbol.txt", sep="\t", header=FALSE)
colnames(ensembl) = c("GeneID", "Symbol")

# symbol -> geneid
colnames(fantom5)[1] = "Symbol"
fantom5 = merge(fantom5, ensembl, by="Symbol")
colnames(fantom5)[4] = "GENEID_L"
fantom5 = fantom5[, 2:4]
colnames(fantom5)[1] = "Symbol"
fantom5 = merge(fantom5, ensembl, by="Symbol")
colnames(fantom5)[4] = "GENEID_R"
fantom5 = fantom5[, c(3,4,2)]

LRname <- unique(fantom5[,1:2])
tmp <- apply(LRname, 1, function(x){
	target <- intersect(
		which(fantom5[,1] == x[1]),
		which(fantom5[,2] == x[2]))
	out <- fantom5[target,3]
	out <- unique(out)
	paste(out, collapse="|")
})
fantom5 <- cbind(LRname, tmp, "FANTOM5")
colnames(fantom5)[3] = "PMID_PPI"
colnames(fantom5)[4] = "SOURCEDB"

fantom5$PMID_PPI <- gsub(", ", "|", fantom5$PMID_PPI)

# Save
write.table(fantom5, file="data/fantom5/fantom5.csv",
	row.names=FALSE, quote=FALSE, sep=",")