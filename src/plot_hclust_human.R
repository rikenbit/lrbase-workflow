source("src/functions.R")

lrbase <- read.csv('data/csv/9606.csv', stringsAsFactors=FALSE, header=TRUE)
fantom5 = lrbase[which(lrbase$SOURCEDB == "FANTOM5"), ]
cellphonedb = lrbase[which(lrbase$SOURCEDB == "CELLPHONEDB"), ]
baderlab = lrbase[which(lrbase$SOURCEDB == "BADERLAB"), ]
singlecellsignalr = lrbase[which(lrbase$SOURCEDB == "SINGLECELLSIGNALR"), ]

# Phylogenetic tree
d <- matrix(0, nrow=length(lrnames), ncol=length(lrnames))
rownames(d) <- lrnames
colnames(d) <- lrnames
tmp <- expand.grid(lrnames, lrnames)
apply(tmp, 1, function(x){
  A <- eval(parse(text=x[1]))
  B <- eval(parse(text=x[2]))
  d[x[1], x[2]] <<- JaccardDistance(
    paste(A$GENEID_L, A$GENEID_R),
    paste(B$GENEID_L, B$GENEID_R))
})
rownames(d) <- lrnames2
colnames(d) <- lrnames2
d <- as.dist(d)
result <- hclust(d, method="ward.D2")

# Plot
png(file='plot/hclust_human.png', width=500, height=500)
plot(result, hang=-1)
dev.off()