# Data loading
fantom5 <- read.delim("data/fantom5/PairsLigRec.txt",  stringsAsFactor=FALSE, header=TRUE, sep="\t")
fantom5 <- fantom5[, c("Ligand.ApprovedSymbol", "Receptor.ApprovedSymbol", "PMID.Manual")]
fantom5 <- fantom5[intersect(which(fantom5[,1] != ""), which(fantom5[,2] != "")), ]

# No PMID
fantom5$PMID.Manual[which(fantom5$PMID.Manual == "")] <- "-"

# Replace ", " with "|"
fantom5$PMID.Manual <- sapply(fantom5$PMID.Manual, function(x){
                sub(", ", "|", x)
        })
colnames(fantom5)[3] = "PMID_PPI"

#
# Emsembl（Gene ID - Symbol)
#
ensembl = read.delim("data/ensembl/Hsa_Symbol.txt", sep="\t", header=FALSE)
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

# At the last column, write FANTOM5
fantom5 <- cbind(fantom5, "FANTOM5")
colnames(fantom5)[4] = "SOURCEDB"

# Save
write.table(fantom5, file="data/fantom5/fantom5.csv", row.names=FALSE, quote=FALSE, sep=",")