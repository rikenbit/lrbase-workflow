source("src/functions.R")

lrbase = read.csv('data/csv/9606.csv', stringsAsFactors=FALSE, header=TRUE)[,1:2]
fantom5 = read.csv('data/fantom5/fantom5.csv', stringsAsFactors=FALSE, header=TRUE)[,1:2]
cellphonedb = read.csv('data/cellphonedb/cellphonedb.csv', stringsAsFactors=FALSE, header=TRUE)[,1:2]
baderlab = read.csv('data/baderlab/baderlab.csv', stringsAsFactors=FALSE, header=TRUE)[,1:2]
singlecellsignalr = read.table('data/singlecellsignalr/lrdb.csv', stringsAsFactors=FALSE, skip=1, sep=",", col.names = paste0("V",seq_len(13)), fill=TRUE)[,1:2]
colnames(singlecellsignalr) <- c("GENEID_L", "GENEID_R")

# Venn diagram
venn.diagram(
  list(LRBase.Hsa.eg.db=unique(paste(lrbase$GENEID_L, lrbase$GENEID_R)),
  	FANTOM5=unique(paste(fantom5$GENEID_L, fantom5$GENEID_R)),
      CellPhoneDB=unique(paste(cellphonedb$GENEID_L, cellphonedb$GENEID_R)),
      BaderLab=unique(paste(baderlab$GENEID_L, baderlab$GENEID_R)),
      SingleCellSignalR=unique(paste(singlecellsignalr$GENEID_L, singlecellsignalr$GENEID_R))
    ),
  filename='plot/venndiagram_human.png',
  imagetype="png",
  scaled=TRUE,
  fill=1:5,
  alpha=rep(0.45, 5),
  cat.cex=1.2,
  margin=0.182
)
