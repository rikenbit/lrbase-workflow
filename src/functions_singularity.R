# Load Packages
library("AnnotationHub")
library("LRBaseDbi")

# Functions/Objects
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
