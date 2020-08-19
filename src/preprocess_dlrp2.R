# データ読み込み
dlrp = read.delim("data/dlrp/pre_dlrp.csv",  stringsAsFactor=FALSE, header=FALSE, sep=",")

#
# Emsembl（Gene ID - Symbol)
#
ensembl = read.delim("data/ensembl/9606_symbol.txt", sep="\t", header=FALSE)
colnames(ensembl) = c("GENEID", "Symbol")

# dlrpのsymbolをGENEIDに
colnames(dlrp)[1] = "Symbol"
dlrp = merge(dlrp, ensembl, by="Symbol")
colnames(dlrp)[5] = "GENEID_L"
dlrp = dlrp[, 2:5]
colnames(dlrp)[1] = "Symbol"
dlrp = merge(dlrp, ensembl, by="Symbol")
colnames(dlrp)[5] = "GENEID_R"
dlrp = dlrp[, c(4,5,2,3)]
colnames(dlrp)[3:4] = c("PMID_PPI", "SOURCEDB")

LRname <- unique(dlrp[,1:2])
tmp <- apply(LRname, 1, function(x){
	target <- intersect(
		which(dlrp[,1] == x[1]),
		which(dlrp[,2] == x[2]))
	out <- dlrp[target,3]
	out <- unique(out)
	paste(out, collapse="|")
})
dlrp <- cbind(LRname, tmp, "DLRP")
colnames(dlrp)[3] = "PMID_PPI"
colnames(dlrp)[4] = "SOURCEDB"

# Save
write.table(dlrp, file="data/dlrp/pre_dlrp2.csv", row.names=FALSE, quote=FALSE, sep=",")
