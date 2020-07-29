source("src/functions.R")

#
# SWISSPROTデータ（細胞内局在、UniProtID, Gene ID）
#
swissprot_secreted = fread(paste0("data/uniprotkb/swissprot_9606_secreted.csv"))
swissprot_membrane = fread(paste0("data/uniprotkb/swissprot_9606_membrane.csv"))
colnames(swissprot_secreted) = c("UniProtID_L", "GENEID_L", "PMID_L")
colnames(swissprot_membrane) = c("UniProtID_R", "GENEID_R", "PMID_R")

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

# swissprotとマージするべく、hprdのsymbolをGENEIDに
colnames(hprd)[1] = "Symbol"
hprd = merge(hprd, ensembl, by="Symbol")
colnames(hprd)[4] = "GENEID_L"
hprd = hprd[, 2:4, with=FALSE]
colnames(hprd)[1] = "Symbol"
hprd = merge(hprd, ensembl, by="Symbol")
colnames(hprd)[4] = "GENEID_R"
hprd = hprd[, 2:4, with=FALSE]

# マージ
swissprot_hprd = merge(hprd, swissprot_secreted, by="GENEID_L")
swissprot_hprd = merge(swissprot_hprd, swissprot_membrane, by="GENEID_R")

swissprot_hprd = swissprot_hprd[, c(1,2,3,5,7), with=FALSE]
swissprot_hprd = cbind(swissprot_hprd, "SWISSPROT_HPRD")
colnames(swissprot_hprd)[6] = "SOURCEDB"

# PMIDは;ではなく|つなぎで
swissprot_hprd[, PMID_PPI:=gsub(";", "|", PMID_PPI)]
swissprot_hprd[, PMID_PPI:=gsub(",", "|", PMID_PPI)]
swissprot_hprd[, PMID_L:=gsub(";", "|", PMID_L)]
swissprot_hprd[, PMID_L:=gsub(",", "|", PMID_L)]
swissprot_hprd[, PMID_R:=gsub(";", "|", PMID_R)]
swissprot_hprd[, PMID_R:=gsub(",", "|", PMID_R)]

# 保存
write.csv(swissprot_hprd, paste0("data/swissprot_hprd/9606.csv"), quote=FALSE, row.names=FALSE)
