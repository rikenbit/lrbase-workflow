source("src/functions.R")

# Parameter
taxid <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

sample_sheet <- read.delim("data/homologene/homologene.data",
	stringsAsFactor=FALSE, header=FALSE)

taxid_pos <- which(sample_sheet[,2] == taxid)
human_pos <- which(sample_sheet[,2] == 9606)
taxid_hid <- unique(sample_sheet[taxid_pos, 1])
human_hid <- unique(sample_sheet[human_pos, 1])
hid <- intersect(taxid_hid, human_hid)

res <- c()
for(i in seq(hid)){
	target <- which(sample_sheet[,1] == i)
	small_sheet <- sample_sheet[target, ]
	geneid_taxid <- small_sheet[which(small_sheet[,2] == taxid), 3]
	geneid_human <- small_sheet[which(small_sheet[,2] == 9606), 3]
	res <- rbind(res, expand.grid(geneid_taxid, geneid_human))
}

colnames(res) <- c(paste0("GENEID_", taxid), "GENEID_9606")

# Ouput
write.csv(res, outfile, quote=FALSE, col.names=FALSE, row.names=FALSE)
