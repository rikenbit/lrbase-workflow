# Command line arguments
metadata_version <- commandArgs(trailingOnly=TRUE)[1]
bioc_version <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]

# Setting
nonzero_sqlites <- list.files("sqlite")
sample_sheet <- read.csv("sample_sheet/sample_sheet.csv", stringsAsFactors=FALSE)
threename <- gsub("LRBase.", "", gsub(".eg.db.sqlite", "", nonzero_sqlites))

target <- unlist(sapply(threename, function(x){
	which(x == sample_sheet$Abbreviation)
}))
sname <- sample_sheet[target, "Scientific.name"]
cname <- sample_sheet[target, "Common.name"]
taxid <- sample_sheet[target, "Taxon.ID"]

title <- c()
description <- c()
tags <- c()
for(i in seq(sname)){
	sn <- sname[i]
	cn <- cname[i]
	if(!is.na(sn) && !is.na(cn)){
		title <- c(title,
			paste0("LRBaseDb for ", sn, " (", cn, ", ", metadata_version, ")"))
		description <- c(description,
			paste0("Correspondence table between Ligand Gene ID and Receptor ID for ", sn, " (", cn, ")"))
		tags <- c(tags, paste0(paste0("LRBaseDb:LRBase:NCBI:Gene:NCBI Gene:FANTOM5:DLRP:IUPHAR:HPRD:STRING:UNIPROTKB:SWISSPROT:TREMBL:ENSEMBL:CELLPHONEDB:BADERLAB:SINGLECELLSIGNALR:BIOMART:HOMOLOGENE:Annotation:LRBase.", threename[i], ".eg.db:"),
			sn, ":", cn, ":", metadata_version))
	}else if(is.na(sn) && !is.na(cn)){
		title <- c(title,
			paste0("LRBaseDb for ", cn, " (", metadata_version, ")"))
		description <- c(description,
			paste0("Correspondence table between Ligand Gene ID and Receptor ID for ", cn))
		tags <- c(tags, paste0(paste0("LRBaseDb:LRBase:NCBI:Gene:NCBI Gene:FANTOM5:DLRP:IUPHAR:HPRD:STRING:UNIPROTKB:SWISSPROT:TREMBL:ENSEMBL:CELLPHONEDB:BADERLAB:SINGLECELLSIGNALR:BIOMART:HOMOLOGENE:Annotation:LRBase.", threename[i], ".eg.db:"),
			cn, ":", metadata_version))
	}else if(!is.na(sn) && is.na(cn)){
		title <- c(title,
			paste0("LRBaseDb for ", sn, " (", metadata_version, ")"))
		description <- c(description,
			paste0("Correspondence table between Ligand Gene ID and Receptor ID for ", sn))
		tags <- c(tags, paste0(paste0("LRBaseDb:LRBase:NCBI:Gene:NCBI Gene:FANTOM5:DLRP:IUPHAR:HPRD:STRING:UNIPROTKB:SWISSPROT:TREMBL:ENSEMBL:CELLPHONEDB:BADERLAB:SINGLECELLSIGNALR:BIOMART:HOMOLOGENE:Annotation:LRBase.", threename[i], ".eg.db:"),
			metadata_version))
	}
}

# sourceurl <- paste(c(
# # FANTOM5
# "http://fantom.gsc.riken.jp/5/suppl/Ramilowski_et_al_2015/data/PairsLigRec.txt",
# "https://www.dropbox.com/s/dvvgudbgbhrlkud/ncomms8866-s3.xlsx?dl=1",
# # DLRP
# "https://www.dropbox.com/s/f2g65zrhrf99ljb/dlrp.txt?dl=1
# mv dlrp.txt?dl=1 data/dlrp/dlrp.txt",
# # IUPHAR
# "http://www.guidetopharmacology.org/DATA/interactions.csv",
# # HPRD
# "http://hprd.org/edownload/HPRD_Release9_041310",
# # STRING
# "https://stringdb-static.org/download/",
# # SWISSPROT
# "ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.dat.gz",
# # TREMBL
# "ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_trembl.dat.gz",
# # ENSEMBL
# "http://www.ensembl.org/biomart",
# "http://plants.ensembl.org/biomart",
# # CELLPHONEDB
# "https://www.dropbox.com/s/66fw400bmoab89a/interactions_cellphonedb.csv?dl=1",
# "https://www.dropbox.com/s/0l7oykri87wpr0x/heterodimers.csv?dl=1",
# # BADERLAB
# " https://www.dropbox.com/s/95mcq48j8osfno1/receptor_ligand_interactions_mitab_v1.0_April2017.txt.zip?dl=0",
# # SINGLECELLSIGNALR
# "https://www.dropbox.com/s/w5t0qgxo8soszd4/LRdb.rda?dl=1",
# # HOMOLOGENE
# "ftp://ftp.ncbi.nih.gov/pub/HomoloGene/current/homologene.data"
# ), collapse=",")
sourceurl <- "https://github.com/rikenbit/lrbase-workflow"

rdatapath <- paste0("AHLRBaseDbs/", metadata_version, "/", nonzero_sqlites)

# Merge
Sys.setlocale("LC_TIME", "C")
out <- data.frame(
	Title = title,
	Description = description,
	BiocVersion = bioc_version,
	Genome = NA,
	SourceType = "CSV",
	SourceUrl = sourceurl,
	SourceVersion = format(Sys.time(), "%d-%b-%Y"),
	Species = sname,
	TaxonomyId = taxid,
	Coordinate_1_based = NA,
	DataProvider = "FANTOM5,DLRP,IUPHAR,HPRD,STRING,SWISSPROT,TREMBL,ENSEMBL,CELLPHONEDB,BADERLAB,SINGLECELLSIGNALR,HOMOLOGENE",
	Maintainer = "Koki Tsuyuzaki <k.t.the-answer@hotmail.co.jp>",
	RDataClass = "SQLiteFile",
	DispatchClass = "FilePath",
	RDataPath = rdatapath,
	Tags = tags
	)

# output
write.csv(out, outfile, row.names=FALSE)