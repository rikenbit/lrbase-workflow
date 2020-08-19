# Data loading
load("data/summary.RData")

# Known
ENSEMBL = read.csv('id/ensembl/ensembl_samples.csv', stringsAsFactors=FALSE)[,c("Common.name", "Scientific.name", "Abbreviation", "Taxon.ID")]
NCBI = read.csv('id/ncbi/ncbi_samples.csv', stringsAsFactors=FALSE)[,c("Common.name", "Scientific.name", "Abbreviation", "Taxon.ID")]
MESH1 <- unlist(read.csv('id/mesh/commonname.txt', stringsAsFactors=FALSE, header=FALSE))
MESH2 <- unlist(read.csv('id/mesh/name.txt', stringsAsFactors=FALSE, header=FALSE))
MESH3 <- unlist(read.csv('id/mesh/threename.txt', stringsAsFactors=FALSE, header=FALSE))
MESH4 <- unlist(read.csv('id/mesh/taxid.txt', stringsAsFactors=FALSE, header=FALSE))
MESH <- data.frame(
	Common.name=as.character(MESH1),
	Scientific.name=as.character(MESH2),
	Abbreviation=as.character(MESH3),
	Taxon.ID=as.character(MESH4))
KNOWN <- rbind(ENSEMBL, NCBI, MESH)

PUTATIVE = read.csv('id/putative_sample_sheet.csv', stringsAsFactors=FALSE, header=FALSE)
PUTATIVE = data.frame(
	Common.name=as.character(PUTATIVE[,4]),
	Scientific.name=as.character(PUTATIVE[,3]),
	Abbreviation=as.character(PUTATIVE[,2]),
	Taxon.ID=as.character(PUTATIVE[,1])
)
ORGINFO = rbind(KNOWN, PUTATIVE)

# Merge
out <- merge(gdata, ORGINFO, by.x="Name", by.y="Scientific.name")
out <- unique(out)
for(i in 1:ncol(out)){
	out[,i] <- as.character(out[,i])
}

# Name, Common Name, Taxonomy ID, SOURCEDBs
nn <- length(unique(out$Name))
nc <- length(unique(out$Common.name))
nt <- length(unique(out$Taxon.ID))
na <- length(unique(out$Abbreviation))
check1 <- nn == nt
check2 <- nt == na
check3 <- nn >= nc

target.org <- as.character(unique(gdata$Name))

if(check1 && check2 && check3){
	# Shrink in each organism
	tmp <- t(sapply(target.org, function(x, out){
		target <- which(out$Name == x)
		Scientific.name=x
		Abbreviation=unique(out[target, 5])
		SOURCEDB=paste(unique(out[target, 3]), collapse="|")
		Common.name=unique(out[target, 4])
		Taxon.ID=unique(out[target, 6])
		No.LR=sum(as.numeric(out[target, 2]))
		c(Scientific.name, Abbreviation, SOURCEDB, Common.name, Taxon.ID, No.LR)
	}, out=out))
	colnames(tmp) <- c("Scientific.name", "Abbreviation", "SOURCEDB", "Common.name", "Taxon.ID", "No.LR")
	# Sort
	tmp <- tmp[order(as.numeric(tmp[,6]), decreasing=TRUE), ]
	# Ouput
	write.csv(tmp, "sample_sheet.csv", quote=FALSE, row.names=FALSE)
}else{
	stop("Duplicated Name, Common.name, or Abbreviation!!!")
}