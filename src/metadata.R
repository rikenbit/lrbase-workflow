source("src/functions_singularity.R")

# Data loading
sample_sheet <- read.csv("sample_sheet.csv", stringsAsFactors=FALSE)
ah <- AnnotationHub()

for(i in 1:nrow(sample_sheet)){
	orginfo <- as.vector(sample_sheet[i, ])
	taxid <- orginfo$Taxon.ID
	outfile <- paste0("data/metadata/", taxid, ".csv")

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
	out <- rbind(out, c("DBSCHEMA", paste0("LRBase.", orginfo$Abbreviation, ".eg.db")))

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
