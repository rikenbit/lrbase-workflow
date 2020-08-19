source("src/functions.R")

lrbase <- read.csv('data/csv/9606.csv', stringsAsFactors=FALSE, header=TRUE)
fantom5 = lrbase[which(lrbase$SOURCEDB == "FANTOM5"), ]
cellphonedb = lrbase[which(lrbase$SOURCEDB == "CELLPHONEDB"), ]
baderlab = lrbase[which(lrbase$SOURCEDB == "BADERLAB"), ]
singlecellsignalr = lrbase[which(lrbase$SOURCEDB == "SINGLECELLSIGNALR"), ]

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
