v = commandArgs(trailingOnly=TRUE)[1] # v11.0

# Data loading
# Human
dlrp <- read.csv("data/dlrp/pre_dlrp2.csv")
iuphar <- read.csv("data/iuphar/iuphar.csv")
hpmr <- read.csv("data/hpmr/hpmr.csv")
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

# 3. HPMR (Human)
p3 <- nrow(hpmr)

# 4. ENSEMBL_DLRP (Other species)
p4 <- lapply(taxid_ensembl, function(x, v){
	filename <- paste0("data/ensembl_dlrp/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p4 <- unlist(p4)

# 5. ENSEMBL_IUPHAR (Other species)
p5 <- lapply(taxid_ensembl, function(x, v){
	filename <- paste0("data/ensembl_iuphar/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p5 <- unlist(p5)

# 6. ENSEMBL_HPMR (Other species)
p6 <- lapply(taxid_ensembl, function(x, v){
	filename <- paste0("data/ensembl_hpmr/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p6 <- unlist(p6)

# 7. NCBI_DLRP (Other species)
p7 <- lapply(taxid_ncbi, function(x, v){
	filename <- paste0("data/ncbi_dlrp/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p7 <- unlist(p7)

# 8. NCBI_IUPHAR (Other species)
p8 <- lapply(taxid_ncbi, function(x, v){
	filename <- paste0("data/ncbi_iuphar/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p8 <- unlist(p8)

# 9. NCBI_HPMR (Other species)
p9 <- lapply(taxid_ncbi, function(x, v){
	filename <- paste0("data/ncbi_hpmr/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p9 <- unlist(p9)

# 10. RBBH_DLRP (Other species)
p10 <- lapply(taxid_rbbh, function(x, v){
	filename <- paste0("data/rbbh_dlrp/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p10 <- unlist(p10)

# 11. RBBH_IUPHAR (Other species)
p11 <- lapply(taxid_rbbh, function(x, v){
	filename <- paste0("data/rbbh_iuphar/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p11 <- unlist(p11)

# 12. RBBH_HPMR (Other species)
p12 <- lapply(taxid_rbbh, function(x, v){
	filename <- paste0("data/rbbh_hpmr/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p12 <- unlist(p12)

# 13. SWISSPROT_HPRD (Human)
p13 <- nrow(swissprot_hprd)

# 14. TREMBL_HPRD (Human)
p14 <- nrow(trembl_hprd)

# 15. SWISSPROT_STRING (Other species)
p15 <- lapply(taxid_putative, function(x, v){
	filename <- paste0("data/swissprot_string/", x, "_", v, "_high.csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p15 <- unlist(p15)

# 16. TREMBL_STRING (Other species)
p16 <- lapply(taxid_putative, function(x, v){
	filename <- paste0("data/trembl_string/", x, "_", v, "_high.csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p16 <- unlist(p16)

# Merge
gdata <- data.frame(
	Name=c(
		"Homo sapiens", "Homo sapiens", "Homo sapiens",
		sname_ensembl, sname_ensembl, sname_ensembl,
		sname_ncbi, sname_ncbi, sname_ncbi,
		sname_rbbh, sname_rbbh, sname_rbbh,
		"Homo sapiens", "Homo sapiens",
		sname_putative, sname_putative),

	Coverage=c(p1, p2, p3, p4, p5, p6,
		p7, p8, p9, p10, p11, p12,
		p13, p14, p15, p16),
	Type=c(
		rep("DLRP", length(p1)),
		rep("IUPHAR", length(p2)),
		rep("HPMR", length(p3)),
		rep("ENSEMBL_DLRP", length(p4)),
		rep("ENSEMBL_IUPHAR", length(p5)),
		rep("ENSEMBL_HPMR", length(p6)),
		rep("NCBI_DLRP", length(p7)),
		rep("NCBI_IUPHAR", length(p8)),
		rep("NCBI_HPMR", length(p9)),
		rep("RBBH_DLRP", length(p10)),
		rep("RBBH_IUPHAR", length(p11)),
		rep("RBBH_HPMR", length(p12)),
		rep("SWISSPROT_HPRD", length(p13)),
		rep("TREMBL_HPRD", length(p14)),
		rep("SWISSPROT_STRING", length(p15)),
		rep("TREMBL_STRING", length(p16))))

# Save
save(gdata, file="data/summary.RData")