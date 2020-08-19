source("src/functions.R")

# データ読み込み
CP <- read.delim("data/cellphonedb/interactions_cellphonedb.csv",
	stringsAsFactor=FALSE, header=TRUE, sep=",")
CP <- CP[, c("partner_a", "partner_b",
	"entry_name_a", "entry_name_b", "comments_interaction")]
Htable <- select(Homo.sapiens,
	columns=c("GENEID", "ALIAS"),
	keytype="GENEID",
	keys=keys(Homo.sapiens, keytype="GENEID"))

####################################################
# 1 vs 1
####################################################
oneByone <- intersect(which(CP$entry_name_a != ""), which(CP$entry_name_b != ""))

# GENEID_L
ALIAS_L <- gsub("_HUMAN", "", CP$entry_name_a[oneByone])
GENEID_L <- unlist(lapply(ALIAS_L, function(x){
	out <- unique(Htable[which(Htable[, "ALIAS"] == x), "GENEID"])[1]
	if(length(out) == 0){
		""
	}else{
		out
	}
}))

# GENEID_R
ALIAS_R <- gsub("_HUMAN", "", CP$entry_name_b[oneByone])
GENEID_R <- unlist(lapply(ALIAS_R, function(x){
	out <- unique(Htable[which(Htable[, "ALIAS"] == x), "GENEID"])[1]
	if(length(out) == 0){
		""
	}else{
		out
	}
}))

# PMID_PPI
Comments <- CP$comments_interaction[oneByone]
PMID_PPI <- unlist(lapply(Comments, function(x){
	m <- regexpr("[0-9][0-9][0-9][0-9][0-9][0-9][0-9]", x)
	substr(x, m, m + attr(m, "match.length") - 1)
}))

# まずマージ
cellphonedb <- data.frame(GENEID_L=GENEID_L, GENEID_R=GENEID_R,
	PMID_PPI=PMID_PPI)


####################################################
# Complex
####################################################
complex <- setdiff(1:nrow(CP), oneByone)
HD = read.delim("data/cellphonedb/heterodimers.csv",
	stringsAsFactor=FALSE, header=TRUE, sep=",")

# GENEID_L
Comp_GENEID_L <- lapply(complex, function(x){
	ALIAS_L <- gsub("_HUMAN", "", CP$entry_name_a[x])
	if(ALIAS_L == ""){
		ALIAS_L <- gsub("_HUMAN", "", HD[which(HD$name == gsub("complex:", "", CP$partner_a[x])),
			paste0("entry_name_", 1:4)])
		ALIAS_L <- ALIAS_L[which(ALIAS_L != "")]
	}
	unique(Htable[which(Htable[, "ALIAS"] == ALIAS_L), "GENEID"])
})

# GENEID_R
Comp_GENEID_R <- lapply(complex, function(x){
	ALIAS_R <- gsub("_HUMAN", "", CP$entry_name_b[x])
	if(ALIAS_R == ""){
		ALIAS_R <- gsub("_HUMAN", "", HD[which(HD$name == gsub("complex:", "", CP$partner_b[x])),
			paste0("entry_name_", 1:4)])
		ALIAS_R <- ALIAS_R[which(ALIAS_R != "")]
	}
	unique(Htable[which(Htable[, "ALIAS"] == ALIAS_R), "GENEID"])
})

# PMID_PPI
Comp_Comments <- CP$comments_interaction[complex]
Comp_PMID_PPI <- unlist(lapply(Comments, function(x){
	m <- regexpr("[0-9][0-9][0-9][0-9][0-9][0-9][0-9]", x)
	substr(x, m, m + attr(m, "match.length") - 1)
}))

# L-R merge
cellphonedb_comp <- c()
for(x in 1:length(Comp_GENEID_L)){
	L <- Comp_GENEID_L[[x]]
	R <- Comp_GENEID_R[[x]]
	L <- L[which(!is.na(L))]
	R <- R[which(!is.na(R))]
	if(length(L)*length(R) != 0){
		cellphonedb_comp <- rbind(cellphonedb_comp,
			cbind(expand.grid(L, R) , Comp_PMID_PPI[x]))
	}
}
colnames(cellphonedb_comp) <- c("GENEID_L", "GENEID_R", "PMID_PPI")

##################################################
# Merge
##################################################
cellphonedb <- rbind(cellphonedb, cellphonedb_comp)

LRname <- unique(cellphonedb[,1:2])
tmp <- apply(LRname, 1, function(x){
	target <- intersect(
		which(cellphonedb[,1] == x[1]),
		which(cellphonedb[,2] == x[2]))
	out <- cellphonedb[target,3]
	out <- unique(out)
	paste(out, collapse="|")
})
cellphonedb <- cbind(LRname, tmp, "CELLPHONEDB")
colnames(cellphonedb)[3] = "PMID_PPI"
colnames(cellphonedb)[4] = "SOURCEDB"

# Remove NA
cellphonedb <-cellphonedb[which(!is.na(cellphonedb[,1])), ]
cellphonedb <-cellphonedb[which(!is.na(cellphonedb[,2])), ]

# ""を"-"に変換
cellphonedb <- as.matrix(cellphonedb)
cellphonedb[which(cellphonedb[,3] == ""), 3] <- "-"

# 保存
write.table(cellphonedb, file="data/cellphonedb/cellphonedb.csv",
	row.names=FALSE, quote=FALSE, sep=",")
