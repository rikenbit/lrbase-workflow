# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]
sourcedb <- commandArgs(trailingOnly=TRUE)[4]

# infile1="data/biomart/9646.csv"
# infile2="data/swissprot_hprd/9606.csv"
# outfile="data/ensembl_swissprot_hprd/9646.csv"
# sourcedb="ENSEMBL_SWISSPROT_HPRD"

if(file.info(infile1)$size != 0){
	# Data loading
	if(length(grep("rbbh", infile1)) == 1){
		orthdata = read.csv(infile1, stringsAsFactors=FALSE, header=FALSE)
	}else{
		orthdata = read.csv(infile1, stringsAsFactors=FALSE, header=TRUE)
	}
	ppidata = read.csv(infile2, stringsAsFactors=FALSE)

	# Merge
	out <- c()
	for(i in 1:nrow(ppidata)){
		targetL <- which(as.character(orthdata[,2]) == as.character(ppidata[i,1]))
		targetR <- which(as.character(orthdata[,2]) == as.character(ppidata[i,2]))
		sourceid <- ppidata[i,3]
		if(length(targetL) != 0 && length(targetR) != 0){
			geneidL <- orthdata[targetL, 1]
			geneidR <- orthdata[targetR, 1]
			geneidL <- geneidL[!is.na(geneidL)][1]
			geneidR <- geneidR[!is.na(geneidR)][1]
			tmp <- c(geneidL, geneidR, sourceid, sourcedb)
			out <- rbind(out, tmp)
		}
	}
	out <- unique(out)
	nonNA <- intersect(which(!is.na(out[,1])), which(!is.na(out[,2])))
	out <- out[nonNA, ]

	# Output
	if(!is.null(out)){
		if(!is.vector(out)){
			if(nrow(out) != 0){
				colnames(out) <- c("GENEID_L", "GENEID_R", "SOURCEID", "SOURCEDB")
				rownames(out) <- NULL
				write.table(out, file=outfile, row.names=FALSE, quote=FALSE, sep=",")
			}
		}else{
			file.create(outfile)
		}
	}else{
	file.create(outfile)
	}
}else{
	file.create(outfile)
}