# Data loading
hpmr <- read.delim("data/fantom5/PairsLigRec.txt",  stringsAsFactor=FALSE, header=TRUE, sep="\t")
hpmr <- hpmr[, c("Ligand.ApprovedSymbol", "Receptor.ApprovedSymbol", "PMID.Manual", "DLRP", "HPMR", "IUPHAR")]
hpmr <- hpmr[which(hpmr[,1] != ""), ]
hpmr <- hpmr[which(hpmr[,2] != ""), ]
hpmr <- hpmr[which(hpmr[,5] != ""), ]

# No PMID
hpmr$PMID.Manual[which(hpmr$PMID.Manual == "")] <- "-"

# Replace ", " with "|"
hpmr$PMID.Manual <- sapply(hpmr$PMID.Manual, function(x){
                sub(", ", "|", x)
        })
colnames(hpmr)[3] = "PMID_PPI"

#
# Emsembl（Gene ID - Symbol)
#
ensembl = read.delim("data/ensembl/9606_symbol.txt", sep="\t", header=FALSE)
colnames(ensembl) = c("GeneID", "Symbol")

# symbol -> geneid
colnames(hpmr)[1] = "Symbol"
hpmr = merge(hpmr, ensembl, by="Symbol")

colnames(hpmr)[7] = "GENEID_L"
hpmr = hpmr[, 2:7]

colnames(hpmr)[1] = "Symbol"
hpmr = merge(hpmr, ensembl, by="Symbol")

colnames(hpmr)[7] = "GENEID_R"
hpmr = hpmr[, c(6,7,2)]

LRname <- unique(hpmr[,1:2])
tmp <- apply(LRname, 1, function(x){
	target <- intersect(
		which(hpmr[,1] == x[1]),
		which(hpmr[,2] == x[2]))
	out <- hpmr[target,3]
	out <- unique(out)
	paste(out, collapse="|")
})
hpmr <- cbind(LRname, tmp, "HPMR")
colnames(hpmr)[3] = "PMID_PPI"
colnames(hpmr)[4] = "SOURCEDB"

# Save
write.table(hpmr, file="data/hpmr/hpmr.csv", row.names=FALSE, quote=FALSE, sep=",")
