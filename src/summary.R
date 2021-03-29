v = commandArgs(trailingOnly=TRUE)[1] # v11.0

# Data loading
# Human specific databases
human <- read.csv("data/csv/9606.csv")

dlrp <- human[which(human$SOURCEDB == "DLRP"), ]
iuphar <- human[which(human$SOURCEDB == "IUPHAR"), ]
hpmr <- human[which(human$SOURCEDB == "HPMR"), ]
cellphonedb <- human[which(human$SOURCEDB == "CELLPHONEDB"), ]
singlecellsignalr <- human[which(human$SOURCEDB == "SINGLECELLSIGNALR"), ]

fantom5 <- human[which(human$SOURCEDB == "FANTOM5"), ]
baderlab <- human[which(human$SOURCEDB == "BADERLAB"), ]
swissprot_hprd <- human[which(human$SOURCEDB == "SWISSPROT_HPRD"), ]
trembl_hprd <- human[which(human$SOURCEDB == "TREMBL_HPRD"), ]

# Ensembl (158)
ensembl <- read.csv("sample_sheet/ensembl.csv", stringsAsFactors=FALSE)
sname_ensembl <- unique(unlist(ensembl['Scientific.name']))
taxid_ensembl <- unique(unlist(ensembl['Taxon.ID']))

# NCBI (20)
ncbi <- read.csv("sample_sheet/ncbi.csv", stringsAsFactors=FALSE)
sname_ncbi <- unique(unlist(ncbi['Scientific.name']))
taxid_ncbi <- unique(unlist(ncbi['Taxon.ID']))

# RBBH (114)
rbbh <- read.csv("sample_sheet/114.csv", stringsAsFactors=FALSE)
sname_rbbh <- rbbh$Scientific.name
taxid_rbbh <- rbbh$Taxon.ID

# Putative (12)
putative <- read.csv("sample_sheet/putative.csv",
	header=TRUE, stringsAsFactors=FALSE)
sname_putative <- unique(unlist(putative[,3]))
taxid_putative <- unique(unlist(putative[,1]))

# 1. DLRP (Human)
p1 <- nrow(dlrp)

# 2. IUPHAR (Human)
p2 <- nrow(iuphar)

# 3. HPMR (Human)
p3 <- nrow(hpmr)

# 4. CellPhoneDB (Human)
p4 <- nrow(cellphonedb)

# 5. SingleCellSignalR (Human)
p5 <- nrow(singlecellsignalr)

# 6. FANTOM5 (Human)
p6 <- nrow(fantom5)

# 7. BaderLab (Human)
p7 <- nrow(baderlab)

# 8. ENSEMBL_DLRP (other species)
p8 <- lapply(taxid_ensembl, function(x, v){
	filename <- paste0("data/ensembl_dlrp/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p8 <- unlist(p8)

# 9. ENSEMBL_IUPHAR (other species)
p9 <- lapply(taxid_ensembl, function(x, v){
	filename <- paste0("data/ensembl_iuphar/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p9 <- unlist(p9)

# 10. ENSEMBL_HPMR (other species)
p10 <- lapply(taxid_ensembl, function(x, v){
	filename <- paste0("data/ensembl_hpmr/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p10 <- unlist(p10)

# 11. ENSEMBL_CELLPHONEDB (other species)
p11 <- lapply(taxid_ensembl, function(x, v){
	filename <- paste0("data/ensembl_cellphonedb/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p11 <- unlist(p11)

# 12. ENSEMBL_SINGLECELLSIGNALR (other species)
p12 <- lapply(taxid_ensembl, function(x, v){
	filename <- paste0("data/ensembl_singlecellsignalr/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p12 <- unlist(p12)

# 13. NCBI_DLRP (other species)
p13 <- lapply(taxid_ncbi, function(x, v){
	filename <- paste0("data/ncbi_dlrp/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p13 <- unlist(p13)

# 14. NCBI_IUPHAR (other species)
p14 <- lapply(taxid_ncbi, function(x, v){
	filename <- paste0("data/ncbi_iuphar/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p14 <- unlist(p14)

# 15. NCBI_HPMR (other species)
p15 <- lapply(taxid_ncbi, function(x, v){
	filename <- paste0("data/ncbi_hpmr/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p15 <- unlist(p15)

# 16. NCBI_CELLPHONEDB (other species)
p16 <- lapply(taxid_ncbi, function(x, v){
	filename <- paste0("data/ncbi_cellphonedb/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p16 <- unlist(p16)

# 17. NCBI_SINGLECELLSIGNALR (other species)
p17 <- lapply(taxid_ncbi, function(x, v){
	filename <- paste0("data/ncbi_singlecellsignalr/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p17 <- unlist(p17)

# 18. RBBH_DLRP (other species)
p18 <- lapply(taxid_rbbh, function(x, v){
	filename <- paste0("data/rbbh_dlrp/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p18 <- unlist(p18)

# 19. RBBH_IUPHAR (other species)
p19 <- lapply(taxid_rbbh, function(x, v){
	filename <- paste0("data/rbbh_iuphar/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p19 <- unlist(p19)

# 20. RBBH_HPMR (other species)
p20 <- lapply(taxid_rbbh, function(x, v){
	filename <- paste0("data/rbbh_hpmr/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p20 <- unlist(p20)

# 21. RBBH_CELLPHONEDB (other species)
p21 <- lapply(taxid_rbbh, function(x, v){
	filename <- paste0("data/rbbh_cellphonedb/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p21 <- unlist(p21)

# 22. RBBH_SINGLECELLSIGNALR (other species)
p22 <- lapply(taxid_rbbh, function(x, v){
	filename <- paste0("data/rbbh_singlecellsignalr/", x, ".csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p22 <- unlist(p22)

# 23. SWISSPROT_HPRD (Human)
p23 <- nrow(swissprot_hprd)

# 24. TREMBL_HPRD (Human)
p24 <- nrow(trembl_hprd)

# 25. SWISSPROT_STRING (all species)
p25 <- lapply(taxid_putative, function(x, v){
	filename <- paste0("data/swissprot_string/", x, "_", v, "_high.csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p25 <- unlist(p25)

# 26. TREMBL_STRING (all species)
p26 <- lapply(taxid_putative, function(x, v){
	filename <- paste0("data/trembl_string/", x, "_", v, "_high.csv")
	if(file.info(filename)$size != 0){
		out <- read.csv(filename)
		nrow(unique(out))
	}else{
		0
	}
}, v=v)
p26 <- unlist(p26)

# Merge
gdata <- data.frame(
	Name=c(
		rep("Homo sapiens", 7),
		rep(sname_ensembl, 5),
		rep(sname_ncbi, 5),
		rep(sname_rbbh, 5),
		rep("Homo sapiens", 2),
		rep(sname_putative, 2)),
	Coverage=c(p1, p2, p3, p4, p5,
		p6, p7, p8, p9, p10,
		p11, p12, p13, p14, p15,
		p16, p17, p18, p19, p20,
		p21, p22, p23, p24, p25,
		p26),
	Type=c(
		rep("DLRP", length(p1)),
		rep("IUPHAR", length(p2)),
		rep("HPMR", length(p3)),
		rep("CELLPHONEDB", length(p4)),
		rep("SINGLECELLSIGNALR", length(p5)),
		rep("FANTOM5", length(p6)),
		rep("BADERLAB", length(p7)),

		rep("ENSEMBL_DLRP", length(p8)),
		rep("ENSEMBL_IUPHAR", length(p9)),
		rep("ENSEMBL_HPMR", length(p10)),
		rep("ENSEMBL_CELLPHONEDB", length(p11)),
		rep("ENSEMBL_SINGLECELLSIGNALR", length(p12)),

		rep("NCBI_DLRP", length(p13)),
		rep("NCBI_IUPHAR", length(p14)),
		rep("NCBI_HPMR", length(p15)),
		rep("NCBI_CELLPHONEDB", length(p16)),
		rep("NCBI_SINGLECELLSIGNALR", length(p17)),

		rep("RBBH_DLRP", length(p18)),
		rep("RBBH_IUPHAR", length(p19)),
		rep("RBBH_HPMR", length(p20)),
		rep("RBBH_CELLPHONEDB", length(p21)),
		rep("RBBH_SINGLECELLSIGNALR", length(p22)),

		rep("SWISSPROT_HPRD", length(p23)),
		rep("TREMBL_HPRD", length(p24)),

		rep("SWISSPROT_STRING", length(p25)),
		rep("TREMBL_STRING", length(p26))))

# Thresholding
target.org <- unlist(lapply(as.character(unique(gdata$Name)), function(x){
	score <- gdata[which(gdata$Name == x), 2]
	if(sum(score) >= 100){
		return(x)
	}
}))
target <- unlist(lapply(target.org, function(x){
	which(gdata$Name == x)
}))
gdata <- gdata[target, ]
gdata <- gdata[which(gdata$Coverage != 0), ]

# Save
save(gdata, file="data/summary.RData")