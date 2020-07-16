source("src/functions.R")

# Human
con <-  dbconn(LRBase.Hsa.eg.db)
dlrp <- dbGetQuery(con, "SELECT * FROM DATA WHERE SOURCEDB = 'DLRP'")
iuphar <- dbGetQuery(con, "SELECT * FROM DATA WHERE SOURCEDB = 'IUPHAR'")

# Other species
ensembl <- read.csv("ensembl_samples.csv", stringsAsFactor=FALSE)
sname_ensembl <- unique(unlist(ensembl['Scientific.name']))
taxid_ensembl <- unique(unlist(ensembl['Taxon.ID']))
ncbi <- read.csv("ncbi_samples.csv", stringsAsFactor=FALSE)
sname_ncbi <- unique(unlist(ncbi['Scientific.name']))
taxid_ncbi <- unique(unlist(ncbi['Taxon.ID']))

# Scientific.name/Percentage/{Ensembl_DLRP,NCBI}の順

# DLRP × Ensembl
p1 <- .lapply_pb(taxid_ensembl, function(x){
	filename <- paste0("data/biomart/", x, ".csv")
	ensdata <- read.csv(filename)
	out <- apply(dlrp, 1, function(xx){
		hitL <- length(which(ensdata[,2] == xx[1]))
		hitR <- length(which(ensdata[,2] == xx[2]))
		if(hitL*hitR != 0){
			1
		}else{
			0
		}
	})
	sum(out)
})
p1 <- unlist(p1)

# DLRP × NCBI
p2 <- .lapply_pb(taxid_ncbi, function(x){
	filename <- paste0("data/homologene/", x, ".csv")
	ndata <- read.csv(filename)
	out <- apply(dlrp, 1, function(xx){
		hitL <- length(which(ndata[,2] == xx[1]))
		hitR <- length(which(ndata[,2] == xx[2]))
		if(hitL*hitR != 0){
			1
		}else{
			0
		}
	})
	sum(out)
})
p2 <- unlist(p2)

# IUPHAR × Ensembl
p3 <- .lapply_pb(taxid_ensembl, function(x){
	filename <- paste0("data/biomart/", x, ".csv")
	ensdata <- read.csv(filename)
	out <- apply(iuphar, 1, function(xx){
		hitL <- length(which(ensdata[,2] == xx[1]))
		hitR <- length(which(ensdata[,2] == xx[2]))
		if(hitL*hitR != 0){
			1
		}else{
			0
		}
	})
	sum(out)
})
p3 <- unlist(p3)

# IUPHAR × NCBI
p4 <- .lapply_pb(taxid_ncbi, function(x){
	filename <- paste0("data/homologene/", x, ".csv")
	ndata <- read.csv(filename)
	out <- apply(iuphar, 1, function(xx){
		hitL <- length(which(ndata[,2] == xx[1]))
		hitR <- length(which(ndata[,2] == xx[2]))
		if(hitL*hitR != 0){
			1
		}else{
			0
		}
	})
	sum(out)
})
p4 <- unlist(p4)

# Merge
gdata <- data.frame(
	Name=c(sname_ensembl, sname_ncbi,
		sname_ensembl, sname_ncbi),
	Coverage=c(p1, p2, p3, p4),
	Type=c(
		rep("Ensembl_DLRP", length(p1)),
		rep("NCBI_DLRP", length(p2)),
		rep("Ensembl_IUPHAR", length(p3)),
		rep("NCBI_IUPHAR", length(p4))))

# Save
save(gdata, file="data/coverage_summary.RData")