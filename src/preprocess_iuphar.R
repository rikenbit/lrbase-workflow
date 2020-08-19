iuphar <- read.csv("data/iuphar/interactions.csv",  stringsAsFactor=FALSE)
iuphar <- iuphar[which(iuphar$target_species == "Human"), ]
iuphar <- iuphar[, c("ligand_gene_symbol", "target_gene_symbol", "pubmed_id")]
iuphar <- iuphar[intersect(which(iuphar[,1] != ""), which(iuphar[,2] != "")), ]

iuphar2 <- c()
for(i in 1:nrow(iuphar)){
	if(length(grep("\\|", iuphar[i,1])) || length(grep("\\|", iuphar[i,2]))){
		ligand <- unlist(strsplit(iuphar[i, 1], "\\|"))
		receptor <- unlist(strsplit(iuphar[i, 2], "\\|"))
		ligand <- rep(ligand, each=length(receptor))
		receptor <- rep(receptor, length(ligand))
		lr <- cbind(ligand, receptor, iuphar[i, 3])
		colnames(lr) <- c("ligand_gene_symbol", "target_gene_symbol", "pubmed_id")
		iuphar2 <- rbind(iuphar2, lr)
		rm(lr)
	}else{
		iuphar2 <- rbind(iuphar2, iuphar[i,])
	}
}
iuphar = iuphar2

#
# Emsembl（Gene ID - Symbol)
#
ensembl = read.delim("data/ensembl/9606_symbol.txt", sep="\t", header=FALSE)
colnames(ensembl) = c("GENEID", "Symbol")

# iupharのsymbolをGENEIDに
colnames(iuphar)[1] = "Symbol"
iuphar = merge(iuphar, ensembl, by="Symbol")
colnames(iuphar)[4] = "GENEID_L"
iuphar = iuphar[, 2:4]
colnames(iuphar)[1] = "Symbol"
iuphar = merge(iuphar, ensembl, by="Symbol")
colnames(iuphar)[4] = "GENEID_R"
iuphar = iuphar[, c(3,4,2)]

LRname <- unique(iuphar[,1:2])
tmp <- apply(LRname, 1, function(x){
	target <- intersect(
		which(iuphar[,1] == x[1]),
		which(iuphar[,2] == x[2]))
	out <- iuphar[target,3]
	out <- unique(out)
	paste(out, collapse="|")
})
iuphar <- cbind(LRname, tmp, "IUPHAR")
colnames(iuphar)[3] = "PMID_PPI"
colnames(iuphar)[4] = "SOURCEDB"

# 保存
write.table(iuphar, file="data/iuphar/iuphar.csv", row.names=FALSE, quote=FALSE, sep=",")
