source("src/functions_singularity.R")

metadata = commandArgs(trailingOnly=TRUE)[1]
csvdata = commandArgs(trailingOnly=TRUE)[2]
taxid = commandArgs(trailingOnly=TRUE)[3]
v = commandArgs(trailingOnly=TRUE)[4]

# metadata = "data/metadata/9606.csv"
# csvdata = "data/csv/9606.csv"
# taxid = "9606"
# v = "2.0.0"

sample_sheet <- read.csv("sample_sheet.csv", header=TRUE)
METADATA <- read.csv(metadata, header=TRUE)
DATA <- read.csv(csvdata, header=TRUE)
THREENAME <- as.character(sample_sheet$Abbreviation[which(sample_sheet$Taxon.ID == taxid)])
NAME <- as.character(sample_sheet$Scientific.name[which(sample_sheet$Taxon.ID == taxid)])
COMMONNAME <- as.character(sample_sheet$Common.name[which(sample_sheet$Taxon.ID == taxid)])

makeLRBasePackage(
    pkgname = paste0("LRBase.", THREENAME, ".eg.db"),
    data = DATA,
    metadata = METADATA,
    organism = NAME,
    pkgtitle = paste0("Ligand-Receptor list for ",
    NAME, " (", THREENAME, ", ", COMMONNAME,
    ", Taxonomy ID: ", taxid, ")"),
    pkgdescription = paste("Contains the LRBaseDb object",
    "to access data from several related annotation packages."),
    version = v,
    maintainer = "Koki Tsuyuzaki <k.t.the-answer@hotmail.co.jp>",
    author="Koki Tsuyuzaki",
    destDir = "rpackages",
    license = "Artistic-2.0")

print(sessionInfo())