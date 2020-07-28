# 例 org="9606"
org=commandArgs(trailingOnly=TRUE)[1]

# 1. Accession
# 2. Location
# 3. Gene ID
# 4. PMID
input <- try(read.delim(paste0("data/uniprotkb/swissprot_", org, ".csv"), sep=",", header=FALSE))

if(class(input) != "try-error"){
	colnames(input) <- NULL

	# LocationでSecretedがあるやつだけを保存
	write.csv(input[grep("secreted", input[, 2], ignore.case=TRUE), c(1,3,4)], paste0("data/uniprotkb/swissprot_", org, "_secreted.csv"), row.names=FALSE, quote=FALSE)
}