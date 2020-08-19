source("src/functions.R")

# Parameter
infile1 = commandArgs(trailingOnly=TRUE)[1]
infile2 = commandArgs(trailingOnly=TRUE)[2]
outfile = commandArgs(trailingOnly=TRUE)[3]

# Data loading
uniprotkb_string <- read.csv(infile1)
lrbase <- read.csv(infile2, stringsAsFactors=FALSE, header=TRUE)
fantom5 = lrbase[which(lrbase$SOURCEDB == "FANTOM5"), ]
iuphar = lrbase[which(lrbase$SOURCEDB == "IUPHAR"), ]
dlrp = lrbase[which(lrbase$SOURCEDB == "DLRP"), ]
hpmr = lrbase[which(lrbase$SOURCEDB == "HPMR"), ]

if(length(grep("swissprot_string", infile1)) == 1){
	Name <- "SWISSPROT_STRING"
}else{
	Name <- "TREMBL_STRING"
}

# Venn diagram
venn.diagram(
  list(FANTOM5=unique(paste(fantom5$GENEID_L, fantom5$GENEID_R)),
      DLRP=unique(paste(dlrp$GENEID_L, dlrp$GENEID_R)),
      IUPHAR=unique(paste(iuphar$GENEID_L, iuphar$GENEID_R)),
      HPMR=unique(paste(hpmr$GENEID_L, hpmr$GENEID_R)),
      UNIPROTKB_STRING=unique(paste(uniprotkb_string$GENEID_L, uniprotkb_string$GENEID_R))
    ),
  category.names=c("FANTOM5", "DLRP", "IUPHAR", "HPMR", Name),
  filename=outfile,
  imagetype="png",
  scaled=TRUE,
  fill=1:5,
  alpha=rep(0.45, 5),
  cat.cex=0.9,
  margin=0.182
)
