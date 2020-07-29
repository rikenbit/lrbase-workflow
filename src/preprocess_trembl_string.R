source("src/functions.R")

# 例 org="9606"
org=commandArgs(trailingOnly=TRUE)[1]
# 例 v="v11.0"
v=commandArgs(trailingOnly=TRUE)[2]

#
# TREMBLデータ（細胞内局在、UniProtID, Gene ID）
#
trembl_secreted = fread(paste0("data/uniprotkb/trembl_", org, "_secreted.csv"))
trembl_membrane = fread(paste0("data/uniprotkb/trembl_", org, "_membrane.csv"))
ensembl = fread(paste0("data/ensembl/", org, ".txt"))

if(nrow(trembl_secreted) != 0 && nrow(trembl_membrane) != 0 && nrow(ensembl) != 0){
	colnames(trembl_secreted) = c("UniProtID_L", "GENEID_L", "PMID_L")
	colnames(trembl_membrane) = c("UniProtID_R", "GENEID_R", "PMID_R")

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
	# tremblとマージするべく、stringのprotein IDをgeneidに
	colnames(ensembl) = c("GENEID", "protein1")
	string = merge(string, ensembl, by="protein1", allow.cartesian=TRUE)
	colnames(string)[11] = "GENEID_L"

	colnames(ensembl) = c("GENEID", "protein2")
	string = merge(string, ensembl, by="protein2", allow.cartesian=TRUE)
	colnames(string)[12] = "GENEID_R"

	# マージ
	trembl_string = merge(string, trembl_secreted, by="GENEID_L")
	trembl_string = merge(trembl_string, trembl_membrane, by="GENEID_R")
	if(nrow(trembl_string) > 1){
		trembl_string = trembl_string[, c(2,1,5:12,14,16), with=FALSE]
		trembl_string = cbind(trembl_string, "TREMBL_STRING")
		colnames(trembl_string)[13] = "SOURCEDB"

		# PMIDは;ではなく|つなぎで
		trembl_string[, PMID_L:=gsub(";", "|", PMID_L)]
		trembl_string[, PMID_L:=gsub(",", "|", PMID_L)]
		trembl_string[, PMID_R:=gsub(";", "|", PMID_R)]
		trembl_string[, PMID_R:=gsub(",", "|", PMID_R)]

		# Remove NA
		trembl_string = na.omit(trembl_string)

		# 保存
		write.csv(trembl_string, paste0("data/trembl_string/", org, "_", v, ".csv"), quote=FALSE, row.names=FALSE)
	}
}
