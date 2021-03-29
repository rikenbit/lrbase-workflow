# Parameter
args <- commandArgs(trailingOnly=TRUE)
org <- args[1]
v <- args[2]
outfile <- args[3]
# org = "1737458"
# v = "v11.0"

infiles <- c(
	# Known
	paste0("data/ensembl_dlrp/", org, ".csv"),
	paste0("data/ensembl_iuphar/", org, ".csv"),
	paste0("data/ensembl_hpmr/", org, ".csv"),
	paste0("data/ensembl_cellphonedb/", org, ".csv"),
	paste0("data/ensembl_singlecellsignalr/", org, ".csv"),

	paste0("data/ncbi_dlrp/", org, ".csv"),
	paste0("data/ncbi_iuphar/", org, ".csv"),
	paste0("data/ncbi_hpmr/", org, ".csv"),
	paste0("data/ncbi_cellphonedb/", org, ".csv"),
	paste0("data/ncbi_singlecellsignalr/", org, ".csv"),

	paste0("data/rbbh_dlrp/", org, ".csv"),
	paste0("data/rbbh_iuphar/", org, ".csv"),
	paste0("data/rbbh_hpmr/", org, ".csv"),
	paste0("data/rbbh_cellphonedb/", org, ".csv"),
	paste0("data/rbbh_singlecellsignalr/", org, ".csv"),

	# Putative
	paste0("data/swissprot_string/", org, "_", v, "_high.csv"),
	paste0("data/trembl_string/", org, "_", v, "_high.csv"),

	paste0("data/ensembl_swissprot_string/", org, "_", v, "_high.csv"),
	paste0("data/ensembl_trembl_string/", org, "_", v, "_high.csv"),
	paste0("data/ensembl_fantom5/", org, "_", v, "_high.csv"),
	paste0("data/ensembl_baderlab/", org, "_", v, "_high.csv"),

	paste0("data/ncbi_swissprot_string/", org, "_", v, "_high.csv"),
	paste0("data/ncbi_trembl_string/", org, "_", v, "_high.csv"),
	paste0("data/ncbi_fantom5/", org, "_", v, "_high.csv"),
	paste0("data/ncbi_baderlab/", org, "_", v, "_high.csv"),

	paste0("data/rbbh_swissprot_string/", org, "_", v, "_high.csv"),
	paste0("data/rbbh_trembl_string/", org, "_", v, "_high.csv"),
	paste0("data/rbbh_fantom5/", org, "_", v, "_high.csv"),
	paste0("data/rbbh_baderlab/", org, "_", v, "_high.csv")
)

if(org != '9606'){
	# Merge
	out <- data.frame()
	for(i in 1:length(infiles)){
		print(i)
		if(file.exists(infiles[i])){
			tmp <- try(read.csv(infiles[i]))
			if(class(tmp) != "try-error"){
				print(head(tmp))
				cn <- colnames(tmp)
				target <- which(cn == c("PMID_PPI"))
				if(length(target) == 1){
					colnames(tmp)[target] <- "SOURCEID"
				}else{
					target2 <- which(cn == c("SOURCEID"))
					if(length(target2) != 1){
						tmp2 <- apply(tmp[,c("PMID_L", "PMID_R")], 1, function(x){
								paste(x, collapse="|")
							})
						tmp <- cbind(tmp, as.matrix(tmp2))
						colnames(tmp)[length(cn)+1] <- "SOURCEID"
					}
				}
				out <- rbind(out, tmp[, c("GENEID_L", "GENEID_R", "SOURCEID", "SOURCEDB")])
			}
		}
	}
	out <- unique(out)

	# Output
	if(nrow(out) != 0){
		write.table(out, file=outfile, row.names=FALSE, quote=FALSE, sep=",")
	}else{
		file.create(outfile)
	}
}else{
	file.copy("data/csv/pre_9606.csv", "data/csv/9606.csv", overwrite = TRUE)
}