source("src/functions.R")

# Data loading
load("data/singlecellsignalr/LRdb.rda")
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

# 保存
write.table(LRdb, file="data/singlecellsignalr/lrdb.csv",
	row.names=FALSE, quote=FALSE, sep=",")
