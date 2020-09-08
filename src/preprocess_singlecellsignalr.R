source("src/functions.R")

# Data loading
load("data/singlecellsignalr/LRdb.rda")
LRdb[,4] <- gsub(")", "", LRdb[, 4])
symbol <- read.delim('data/ensembl/9606_symbol.txt', header=FALSE)
symbol <- symbol[which(!is.na(symbol[,1])),]

LRdb <- t(apply(LRdb, 1, function(x, symbol){
	targetL <- which(symbol[,2] == x[1])[1]
	targetR <- which(symbol[,2] == x[2])[1]
	if(length(targetL) != 0 && length(targetR) != 0){
		GENEID_L <- symbol[targetL, 1]
		GENEID_R <- symbol[targetR, 1]
	}else{
		GENEID_L <- NA
		GENEID_R <- NA
	}
	c(GENEID_L, GENEID_R, x[3], x[4])
}, symbol=symbol))

LRdb <- LRdb[, c(1,2,4,3)]
colnames(LRdb) <- c("GENEID_L", "GENEID_R", "PMID_PPI", "SOURCEDB")
LRdb <- LRdb[which(!is.na(LRdb[,1])), ]
LRdb <- LRdb[which(!is.na(LRdb[,2])), ]

LRname <- unique(LRdb[,1:2])
tmp <- apply(LRname, 1, function(x){
	target <- intersect(
		which(LRdb[,1] == x[1]),
		which(LRdb[,2] == x[2]))
	out <- LRdb[target,3]
	out <- unique(out)
	paste(out, collapse="|")
})
LRdb <- cbind(LRname, tmp, "SINGLECELLSIGNALR")
colnames(LRdb)[3] = "PMID_PPI"
colnames(LRdb)[4] = "SOURCEDB"

LRdb[, "PMID_PPI"] <- gsub(",", "|", LRdb[, "PMID_PPI"])

# 保存
write.table(LRdb, file="data/singlecellsignalr/lrdb.csv",
	row.names=FALSE, quote=FALSE, sep=",")
