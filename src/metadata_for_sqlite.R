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

# Data loading
sample_sheet <- read.csv("sample_sheet/sample_sheet.csv", stringsAsFactors=FALSE)

for(i in 1:nrow(sample_sheet)){
	orginfo <- as.vector(sample_sheet[i, ])
	taxid <- orginfo$Taxon.ID
	threename <- orginfo$Abbreviation
	outfile <- paste0("data/metadata_for_sqlite/", threename, ".csv")

	# SOURCEDATE
	out <- c()
	out <- rbind(out, c("SOURCEDATE", as.character(Sys.Date())))

	# SOURCENAME
	dbnames <- strsplit(orginfo$SOURCEDB, "\\|")[[1]]
	dbnames <- unlist(strsplit(dbnames, "_"))
	dbnames <- unique(dbnames)
	for(i in 1:length(dbnames)){
		out <- rbind(out, c(paste0("SOURCENAME", i), dbnames[i]))
	}

	# SOURCEURL
	for(i in 1:length(dbnames)){
		out <- rbind(out, c(paste0("SOURCEURL", i), .url[[dbnames[i]]]))
	}

	# DBSCHEMA
	out <- rbind(out, c("DBSCHEMA", paste0("LRBase.", threename, ".eg.db")))

	# DBSCHEMAVERSION
	out <- rbind(out, c("DBSCHEMAVERSION", "1.0"))

	# ORGANISM
	out <- rbind(out, c("ORGANISM", orginfo$Scientific.name))

	# SPECIES
	out <- rbind(out, c("SPECIES", orginfo$Common.name))

	# package
	out <- rbind(out, c("package", "AnnotationDbi"))

	# Db type
	out <- rbind(out, c("Db type", "LRBaseDb"))

	# LRVERSION
	out <- rbind(out, c("LRVERSION", "2018"))

	# TAXID
	out <- rbind(out, c("TAXID", taxid))

	# Output
	colnames(out) <- c("NAME", "VALUE")
	write.csv(out, outfile, quote=FALSE, row.names=FALSE)
}