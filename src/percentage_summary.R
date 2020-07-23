source("src/functions.R")

# Human
con <-  dbconn(LRBase.Hsa.eg.db)
dlrp <- dbGetQuery(con, "SELECT * FROM DATA WHERE SOURCEDB = 'DLRP'")
iuphar <- dbGetQuery(con, "SELECT * FROM DATA WHERE SOURCEDB = 'IUPHAR'")

# Other species
ensembl <- read.csv("id/ensembl/ensembl_samples.csv", stringsAsFactor=FALSE)
sname_ensembl <- unique(unlist(ensembl['Scientific.name']))
taxid_ensembl <- unique(unlist(ensembl['Taxon.ID']))

ncbi <- read.csv("id/ncbi/ncbi_samples.csv", stringsAsFactor=FALSE)
sname_ncbi <- unique(unlist(ncbi['Scientific.name']))
taxid_ncbi <- unique(unlist(ncbi['Taxon.ID']))

sname_mesh <- unlist(read.csv("id/mesh/name.txt", header=FALSE, stringsAsFactor=FALSE))
taxid_mesh <- unlist(read.csv("id/mesh/taxid.txt", header=FALSE, stringsAsFactor=FALSE))

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
	100 * sum(out) / length(out)
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
	100 * sum(out) / length(out)
})
p2 <- unlist(p2)

# DLRP × MeSH
p3 <- .lapply_pb(taxid_mesh, function(x){
	filename <- paste0("data/rbbh/", x, ".csv")
	if(file.info(filename)$size != 0){
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
		100 * sum(out) / length(out)
	}else{
		0
	}
})
p3 <- unlist(p3)

# IUPHAR × Ensembl
p4 <- .lapply_pb(taxid_ensembl, function(x){
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
	100 * sum(out) / length(out)
})
p4 <- unlist(p4)

# IUPHAR × NCBI
p5 <- .lapply_pb(taxid_ncbi, function(x){
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
	100 * sum(out) / length(out)
})
p5 <- unlist(p5)

# IUPHAR × MeSH
p6 <- .lapply_pb(taxid_mesh, function(x){
	filename <- paste0("data/rbbh/", x, ".csv")
	if(file.info(filename)$size != 0){
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
		100 * sum(out) / length(out)
	}else{
		0
	}
})
p6 <- unlist(p6)

# Merge
gdata <- data.frame(
	Name=c(sname_ensembl, sname_ncbi, sname_mesh,
		sname_ensembl, sname_ncbi, sname_mesh),
	Percentage=c(p1, p2, p3, p4, p5, p6),
	Type=c(
		rep("Ensembl_DLRP", length(p1)),
		rep("NCBI_DLRP", length(p2)),
		rep("MeSH_DLRP", length(p3)),
		rep("Ensembl_IUPHAR", length(p4)),
		rep("NCBI_IUPHAR", length(p5)),
		rep("MeSH_IUPHAR", length(p6))))

# Save
save(gdata, file="data/percentage_summary.RData")