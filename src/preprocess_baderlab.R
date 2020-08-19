source("src/functions.R")

# データ読み込み
Bader <- read.delim("data/baderlab/receptor_ligand_interactions_mitab_v1.0_April2017.txt",
	stringsAsFactor=FALSE, header=TRUE)
Bader <- Bader[, c("altA", "altB", "pmids")]
Bader <- Bader[intersect(which(Bader$altA != ""), which(Bader$altB != "")), ]

# GENEID_L（Gene IDがそのまま）
altA_1 <- gsub("entrezgene/locuslink:", "", Bader$altA)
m <- regexpr("^[0-9]*\\|", altA_1)
GENEID_L_1 <- gsub("\\|", "", substr(altA_1, m, m + attr(m, "match.length") - 1))

# GENEID_L（要変換）
altA_2 <- unlist(lapply(seq_along(Bader$altA), function(x){
	info <- strsplit(Bader$altA[x], "\\|")[[1]]
	target <- grep("entrez gene/locuslink:", info)[1]
	if(length(target) == 0){
		""
	}else{
		gsub("entrez gene/locuslink:", "", info[target])
	}
}))
TMP <- select(Homo.sapiens, columns=c("GENEID", "ALIAS"),
	keys=altA_2, keytype="ALIAS")
GENEID_L_2 <- unlist(lapply(altA_2, function(x){
	target <- which(TMP$ALIAS == x)
	if(length(target) == 0){
		""
	}else{
		as.character(TMP[target[1], "GENEID"])
	}
}))

# マージ
GENEID_L <- paste0(GENEID_L_1, GENEID_L_2)


# GENEID_R（Gene IDがそのまま）
altB_1 <- gsub("entrezgene/locuslink:", "", Bader$altB)
m <- regexpr("^[0-9]*\\|", altB_1)
GENEID_R_1 <- gsub("\\|", "", substr(altB_1, m, m + attr(m, "match.length") - 1))

# GENEID_R（要変換）
altB_2 <- unlist(lapply(seq_along(Bader$altB), function(x){
	info <- strsplit(Bader$altB[x], "\\|")[[1]]
	target <- grep("entrez gene/locuslink:", info)[1]
	if(length(target) == 0){
		""
	}else{
		gsub("entrez gene/locuslink:", "", info[target])
	}
}))
TMP <- select(Homo.sapiens, columns=c("GENEID", "ALIAS"),
	keys=altB_2, keytype="ALIAS")
GENEID_R_2 <- unlist(lapply(altB_2, function(x){
	target <- which(TMP$ALIAS == x)
	if(length(target) == 0){
		""
	}else{
		as.character(TMP[target[1], "GENEID"])
	}
}))

# マージ
GENEID_R <- paste0(GENEID_R_1, GENEID_R_2)

# PMID_PPI
PMID_PPI <- gsub("pubmed:", "", Bader$pmid)

# Bader
bader <- data.frame(GENEID_L=GENEID_L, GENEID_R=GENEID_R,
	PMID_PPI=PMID_PPI)

LRname <- unique(bader[,1:2])
tmp <- apply(LRname, 1, function(x){
	target <- intersect(
		which(bader[,1] == x[1]),
		which(bader[,2] == x[2]))
	out <- bader[target,3]
	out <- unique(out)
	paste(out, collapse="|")
})
bader <- cbind(LRname, tmp, "BADERLAB")
colnames(bader)[3] = "PMID_PPI"
colnames(bader)[4] = "SOURCEDB"

# 保存
write.table(bader, file="data/baderlab/baderlab.csv",
	row.names=FALSE, quote=FALSE, sep=",")
