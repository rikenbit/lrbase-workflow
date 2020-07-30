source("src/functions.R")

# Parameter
infile1 = commandArgs(trailingOnly=TRUE)[1]
infile2 = commandArgs(trailingOnly=TRUE)[2]
infile3 = commandArgs(trailingOnly=TRUE)[3]
infile4 = commandArgs(trailingOnly=TRUE)[4]
outfile = commandArgs(trailingOnly=TRUE)[5]

# Data loading
uniprotkb_hprd <- read.csv(infile1)
fantom5 <- read.csv(infile2)
iuphar <- read.csv(infile3)
dlrp <- read.csv(infile4)

if(length(grep("swissprot_hprd", infile1)) == 1){
	Name <- "SWISSPROT_HPRD"
}else{
	Name <- "TREMBL_HPRD"
}

# Venn diagram
venn.diagram(
  list(FANTOM5=unique(paste(fantom5$GENEID_L, fantom5$GENEID_R)),
      DLRP=unique(paste(dlrp$GENEID_L, dlrp$GENEID_R)),
      IUPHAR=unique(paste(iuphar$GENEID_L, iuphar$GENEID_R)),
      UNIPROTKB_HPRD=unique(paste(uniprotkb_hprd$GENEID_L, uniprotkb_hprd$GENEID_R))
    ),
  category.names=c("FANTOM5", "DLRP", "IUPHAR", Name),
  filename=outfile,
  imagetype="png",
  scaled=TRUE,
  fill=1:4,
  alpha=rep(0.45, 4)
)
