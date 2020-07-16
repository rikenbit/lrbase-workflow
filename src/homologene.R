source("src/functions.R")

# Parameter
taxid <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

sample_sheet <- read.delim("homologene.data",
	stringsAsFactor=FALSE, header=FALSE)

taxid_pos <- which(sample_sheet[,2] == taxid)
human_pos <- which(sample_sheet[,2] == 9606)
taxid_hid <- unique(sample_sheet[taxid_pos, 1])
human_hid <- unique(sample_sheet[human_pos, 1])
hid <- intersect(taxid_hid, human_hid)

res1 <- lapply(hid, function(x){
	target <- which(sample_sheet[,1] == x)
	small_sheet <- sample_sheet[target, ]
	target_taxid <- which(small_sheet[,2] == taxid)
	small_sheet[target_taxid, 3]
})

res2 <- lapply(hid, function(x){
	target <- which(sample_sheet[,1] == x)
	small_sheet <- sample_sheet[target, ]
	target_human <- which(small_sheet[,2] == 9606)
	small_sheet[target_human, 3]
})

res <- cbind(res1, res2)

colnames(res) <- c(paste0(taxid, "_GENEID"), "9606_GENEID")

# Ouput
write.csv(res, outfile, quote=FALSE, col.names=FALSE, row.names=FALSE)
