source("src/functions.R")

# Parameter
args <- commandArgs(trailingOnly=TRUE)
infiles <- args[1:(length(args)-1)]
outfile <- args[length(args)]

out <- data.frame()
for(i in 1:length(infiles)){
	print(i)
	tmp <- read.csv(infiles[i])
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
out <- unique(out)

# Output
write.table(out, file=outfile, row.names=FALSE, quote=FALSE, sep=",")