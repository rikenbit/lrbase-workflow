v = commandArgs(trailingOnly=TRUE)[1] # v11.0

# Data loading
# Human
dlrp <- read.csv("data/dlrp/pre_dlrp2.csv")
iuphar <- read.csv("data/iuphar/iuphar.csv")
swissprot_hprd <- read.csv("data/swissprot_hprd/9606.csv")
trembl_hprd <- read.csv("data/trembl_hprd/9606.csv")

# Ensembl (158)
ensembl <- read.csv("id/ensembl/ensembl_samples.csv", stringsAsFactors=FALSE)
sname_ensembl <- unique(unlist(ensembl['Scientific.name']))
taxid_ensembl <- unique(unlist(ensembl['Taxon.ID']))

# NCBI (20)
ncbi <- read.csv("id/ncbi/ncbi_samples.csv", stringsAsFactors=FALSE)
sname_ncbi <- unique(unlist(ncbi['Scientific.name']))
taxid_ncbi <- unique(unlist(ncbi['Taxon.ID']))

# RBBH (100)
sname_rbbh <- unlist(read.csv("id/mesh/name.txt", header=FALSE, stringsAsFactors=FALSE))
taxid_rbbh <- unlist(read.csv("id/mesh/taxid.txt", header=FALSE, stringsAsFactors=FALSE))

# Putative (12)
putative <- read.csv("id/putative_sample_sheet.csv",
	header=FALSE, stringsAsFactors=FALSE)
sname_putative <- unique(unlist(putative[,3]))
taxid_putative <- unique(unlist(putative[,1]))

# 1. DLRP (Human)
p1 <- nrow(dlrp)

# 2. IUPHAR (Human)
p2 <- nrow(iuphar)

# 3. ENSEMBL_DLRP (Other species)
p3 <- lapply(taxid_ensembl, function(x, v){
	filename <- paste0("data/ensembl_dlrp/", x, ".csv")
	if(file.info(filename)$size != 0){
		nrow(read.csv(filename))
	}else{
		0
	}
}, v=v)
p3 <- unlist(p3)

# 4. ENSEMBL_IUPHAR (Other species)
p4 <- lapply(taxid_ensembl, function(x, v){
	filename <- paste0("data/ensembl_iuphar/", x, ".csv")
	if(file.info(filename)$size != 0){
		nrow(read.csv(filename))
	}else{
		0
	}
}, v=v)
p4 <- unlist(p4)

# 5. NCBI_DLRP (Other species)
p5 <- lapply(taxid_ncbi, function(x, v){
	filename <- paste0("data/ncbi_iuphar/", x, ".csv")
	if(file.info(filename)$size != 0){
		nrow(read.csv(filename))
	}else{
		0
	}
}, v=v)
p5 <- unlist(p5)

# 6. NCBI_IUPHAR (Other species)
p6 <- lapply(taxid_ncbi, function(x, v){
	filename <- paste0("data/ncbi_iuphar/", x, ".csv")
	if(file.info(filename)$size != 0){
		nrow(read.csv(filename))
	}else{
		0
	}
}, v=v)
p6 <- unlist(p6)

# 7. RBBH_DLRP (Other species)
p7 <- lapply(taxid_rbbh, function(x, v){
	filename <- paste0("data/rbbh_dlrp/", x, ".csv")
	if(file.info(filename)$size != 0){
		nrow(read.csv(filename))
	}else{
		0
	}
}, v=v)
p7 <- unlist(p7)

# 8. RBBH_IUPHAR (Other species)
p8 <- lapply(taxid_rbbh, function(x, v){
	filename <- paste0("data/rbbh_iuphar/", x, ".csv")
	if(file.info(filename)$size != 0){
		nrow(read.csv(filename))
	}else{
		0
	}
}, v=v)
p8 <- unlist(p8)

# 9. SWISSPROT_HPRD (Human)
p9 <- nrow(swissprot_hprd)

# 10. TREMBL_HPRD (Human)
p10 <- nrow(trembl_hprd)

# 11. SWISSPROT_STRING (Other species)
p11 <- lapply(taxid_putative, function(x, v){
	filename <- paste0("data/swissprot_string/", x, "_", v, "_high.csv")
	if(file.info(filename)$size != 0){
		nrow(read.csv(filename))
	}else{
		0
	}
}, v=v)
p11 <- unlist(p11)

# 12. TREMBL_STRING (Other species)
p12 <- lapply(taxid_putative, function(x, v){
	filename <- paste0("data/trembl_string/", x, "_", v, "_high.csv")
	if(file.info(filename)$size != 0){
		nrow(read.csv(filename))
	}else{
		0
	}
}, v=v)
p12 <- unlist(p12)

# Merge
gdata <- data.frame(
	Name=c(
		"Homo sapiens", "Homo sapiens",
		sname_ensembl, sname_ensembl,
		sname_ncbi, sname_ncbi,
		sname_rbbh, sname_rbbh,
		"Homo sapiens", "Homo sapiens",
		sname_putative, sname_putative),
	Coverage=log10(c(p1, p2, p3, p4, p5, p6,
		p7, p8, p9, p10, p11, p12)+1),
	Type=c(
		rep("DLRP", length(p1)),
		rep("IUPHAR", length(p2)),
		rep("ENSEMBL_DLRP", length(p3)),
		rep("ENSEMBL_IUPHAR", length(p4)),
		rep("NCBI_DLRP", length(p5)),
		rep("NCBI_IUPHAR", length(p6)),
		rep("RBBH_DLRP", length(p7)),
		rep("RBBH_IUPHAR", length(p8)),
		rep("SWISSPROT_HPRD", length(p9)),
		rep("TREMBL_HPRD", length(p10)),
		rep("SWISSPROT_STRING", length(p11)),
		rep("TREMBL_STRING", length(p12))))

# Save
save(gdata, file="data/summary.RData")