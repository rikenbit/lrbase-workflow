source("src/functions.R")

#
# TREMBLデータ（細胞内局在、UniProtID, Gene ID）
#
trembl_secreted = fread(paste0("data/uniprotkb/trembl_9606_secreted.csv"))
trembl_membrane = fread(paste0("data/uniprotkb/trembl_9606_membrane.csv"))
colnames(trembl_secreted) = c("UniProtID_L", "GENEID_L", "PMID_L")
colnames(trembl_membrane) = c("UniProtID_R", "GENEID_R", "PMID_R")

#
# HPRDデータ（PPI、Symbol or RefSeqID）
#
hprd = fread("data/hprd/HPRD_Release9_062910/BINARY_PROTEIN_PROTEIN_INTERACTIONS.txt")
hprd = hprd[, c(1,4,8), with=FALSE]
hprd = rbind(hprd, hprd[, c(2,1,3), with=FALSE])
colnames(hprd) = c("Symbol_L", "Symbol_R", "PMID_PPI")

#
# Emsembl（Gene ID - Symbol)
#
ensembl = fread("data/ensembl/9606_symbol.txt")
colnames(ensembl) = c("GENEID", "Symbol")

# tremblとマージするべく、hprdのsymbolをGENEIDに
colnames(hprd)[1] = "Symbol"
hprd = merge(hprd, ensembl, by="Symbol")
colnames(hprd)[4] = "GENEID_L"
hprd = hprd[, 2:4, with=FALSE]
colnames(hprd)[1] = "Symbol"
hprd = merge(hprd, ensembl, by="Symbol")
colnames(hprd)[4] = "GENEID_R"
hprd = hprd[, 2:4, with=FALSE]

# マージ
trembl_hprd = merge(hprd, trembl_secreted, by="GENEID_L")
trembl_hprd = merge(trembl_hprd, trembl_membrane, by="GENEID_R")

trembl_hprd = trembl_hprd[, c(1,2,3,5,7), with=FALSE]
trembl_hprd = cbind(trembl_hprd, "TREMBL_HPRD")
colnames(trembl_hprd)[6] = "SOURCEDB"

# PMIDは;ではなく|つなぎで
trembl_hprd[, PMID_PPI:=gsub(";", "|", PMID_PPI)]
trembl_hprd[, PMID_PPI:=gsub(",", "|", PMID_PPI)]
trembl_hprd[, PMID_L:=gsub(";", "|", PMID_L)]
trembl_hprd[, PMID_L:=gsub(",", "|", PMID_L)]
trembl_hprd[, PMID_R:=gsub(";", "|", PMID_R)]
trembl_hprd[, PMID_R:=gsub(",", "|", PMID_R)]

# 保存
write.csv(trembl_hprd, paste0("data/trembl_hprd/9606.csv"), quote=FALSE, row.names=FALSE)
