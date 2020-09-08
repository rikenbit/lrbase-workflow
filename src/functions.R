# CRAN packages
library("data.table")
library("ggplot2")
library("RSQLite")
library("gtable")
library("gridExtra")
library("grid")
library("stringr")
library("VennDiagram")

# Bioconductor packages
library("biomaRt")
library("Homo.sapiens")
library("AnnotationHub")
library("AnnotationDbi")
library("ensembldb")
library("GenomicFeatures")

# Name Vectors
lrnames <- c("lrbase", "fantom5", "cellphonedb", "baderlab", "singlecellsignalr")
lrnames2 <- c("LRBase.Hsa.eg.db", "FANTOM5", "CellPhoneDB", "BaderLab", "SingleCellSignalR")

# Functions
JaccardDistance <- function(A, B){
  1 - length(intersect(A, B)) / length(union(A, B))
}

.url <- list(
	DLRP="https://dip.doe-mbi.ucla.edu/dip/DLRP.cgi",
	IUPHAR="https://www.guidetopharmacology.org/download.jsp",
	ENSEMBL="https://asia.ensembl.org/info/genome/compara/homology_method.html",
	NCBI="https://ftp.ncbi.nih.gov/pub/HomoloGene/current/",
	RBBH="https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-015-0453-z",
	SWISSPROT="http://www.uniprot.org/uniprot/?query=reviewed:yes",
	TREMBL="http://www.uniprot.org/uniprot/?query=reviewed:no",
	HPRD="http://hprd.org/download",
	STRING="https://string-db.org/cgi/download.pl"
)

.checkAH <- function(ah, taxid, term){
	mc <- mcols(ah)
	target1 <- which(mc$taxonomyid == taxid)
	target2 <- which(mc$rdataclass == "OrgDb")
	target3 <- which(mc$rdataclass == "EnsDb")
	targetO <- intersect(target1, target2)
	targetE <- intersect(target1, target3)
	checkO <- FALSE
	checkE <- FALSE
	if(length(targetO) != 0){
		ahdata <- ah[[names(ah)[max(targetO)]]]
		checkO1 <- term %in% columns(ahdata)
		checkO2 <- "ENTREZID" %in% columns(ahdata)
		checkO <- checkO1 && checkO2
	}
	if(!checkO && length(targetE) != 0){
		ahdata <- ah[[names(ah)[max(targetE)]]]
		checkE1 <- term %in% columns(ahdata)
		checkE2 <- "ENTREZID" %in% columns(ahdata)
		checkE <- checkE1 && checkE2
	}
	checkO || checkE
}

.checkMeSH <- function(abr){
	abr %in% c("Aca", "Aga.PEST", "Ame", "Aml", "Ana", "Ani.FGSC", "Ath", "Bfl", "Bsu.168", "Bta", "Cal.SC5314", "Cbr", "Cel", "Cfa", "Cin", "Cja", "Cpo", "Cre", "Dan", "Dda.3937", "Ddi.AX4", "Der", "Dgr", "Dme", "Dmo", "Dpe", "Dre", "Dse", "Dsi", "Dvi", "Dya", "Eco.55989", "Eco.ED1a", "Eco.IAI39", "Eco.K12.MG1655", "Eco.O157.H7.Sakai", "Eco.UMN026", "Eqc", "Gga", "Gma", "Hsa", "Laf", "Lma", "Mdo", "Mes", "Mga", "Miy", "Mml", "Mmu", "Mtr", "Nle", "Oan", "Ocu", "Oni", "Osa", "Pab", "Pae.PAO1", "Pfa.3D7", "Pto", "Ptr", "Rno", "Sce.S288c", "Sco.A32", "Sil", "Spu", "Ssc", "Syn", "Tbr.9274", "Tgo.ME49", "Tgu", "Vvi", "Xla", "Xtr", "Zma")
}

.checkReactome <- function(taxid){
	taxid %in% c("44689", "5833", "4896", "4932", "6239", "9823", "9913", "9615", "10090", "10116", "9606", "9031", "8364", "7955", "7227", "1773")
	# D. discoideum: 44689
	# P. falciparum: 5833
	# S. pombe: 4896
	# S. cerevisiae: 4932
	# C. elegans: 6239
	# S. scrofa: 9823
	# B. taurus: 9913
	# C. familiaris: 9615
	# M. musculus: 10090
	# R. norvegicus: 10116
	# H. sapiens: 9606
	# G. gallus: 9031
	# X. tropicalis: 8364
	# D. rerio: 7955
	# D. melanogaster: 7227
	# M. tuberculosis: 1773
	# https://reactome.org/about/statistics
}