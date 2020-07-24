# データ読み込み
dlrp = read.delim("data/dlrp/pre_dlrp.csv",  stringsAsFactor=FALSE, header=FALSE, sep=",")

#
# Emsembl（Gene ID - Symbol)
#
ensembl = read.delim("data/ensembl/Hsa_Symbol.txt", sep="\t", header=FALSE)
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

# 保存
write.table(dlrp, file="data/dlrp/pre_dlrp2.csv", row.names=FALSE, quote=FALSE, sep=",")
