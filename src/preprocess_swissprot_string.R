source("src/functions.R")

# 例 org="9606"
org=commandArgs(trailingOnly=TRUE)[1]
# 例 v="v11.0"
v=commandArgs(trailingOnly=TRUE)[2]

#
# SWISSPROTデータ（細胞内局在、UniProtID, Gene ID）
#
swissprot_secreted = fread(paste0("data/uniprotkb/swissprot_", org, "_secreted.csv"))
swissprot_membrane = fread(paste0("data/uniprotkb/swissprot_", org, "_membrane.csv"))
ensembl = fread(paste0("data/ensembl/", org, ".txt"))

if(nrow(swissprot_secreted) != 0 && nrow(swissprot_membrane) != 0 && nrow(ensembl) != 0){
	colnames(swissprot_secreted) = c("UniProtID_L", "GENEID_L", "PMID_L")
	colnames(swissprot_membrane) = c("UniProtID_R", "GENEID_R", "PMID_R")

	#
	# STRINGデータ（PPI、Ensembl Protein ID）
	#
	string = fread(paste0("data/string/", org, ".protein.links.detailed.", v, ".txt"))
	string[, protein1:=gsub(paste0(org, "."), "", protein1)]
	string[, protein2:=gsub(paste0(org, "."), "", protein2)]
	string = rbind(string, string[, c(2,1,3:10), with=FALSE])

	#
	# Emsembl（Gene ID - Symbol)
	#
	# swissprotとマージするべく、stringのprotein IDをgeneidに
	colnames(ensembl) = c("GENEID", "protein1")
	string = merge(string, ensembl, by="protein1", allow.cartesian=TRUE)
	colnames(string)[11] = "GENEID_L"

	colnames(ensembl) = c("GENEID", "protein2")
	string = merge(string, ensembl, by="protein2", allow.cartesian=TRUE)
	colnames(string)[12] = "GENEID_R"

	# マージ
	swissprot_string = merge(string, swissprot_secreted, by="GENEID_L")
	swissprot_string = merge(swissprot_string, swissprot_membrane, by="GENEID_R")
	if(nrow(swissprot_string) > 1){
		swissprot_string = swissprot_string[, c(2,1,5:12,14,16), with=FALSE]
		swissprot_string = cbind(swissprot_string, "SWISSPROT_STRING")
		colnames(swissprot_string)[13] = "SOURCEDB"

		# PMIDは;ではなく|つなぎで
		swissprot_string[, PMID_L:=gsub(";", "|", PMID_L)]
		swissprot_string[, PMID_L:=gsub(",", "|", PMID_L)]
		swissprot_string[, PMID_R:=gsub(";", "|", PMID_R)]
		swissprot_string[, PMID_R:=gsub(",", "|", PMID_R)]

		# Remove NA
		swissprot_string = na.omit(swissprot_string)

		# 保存
		write.csv(swissprot_string, paste0("data/swissprot_string/", org, "_", v, ".csv"), quote=FALSE, row.names=FALSE)
	}
}