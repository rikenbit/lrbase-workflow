source("src/functions.R")

lrbase = read.csv('data/csv/9606.csv', stringsAsFactors=FALSE, header=TRUE)[,1:2]
fantom5 = read.csv('data/fantom5/fantom5.csv', stringsAsFactors=FALSE, header=TRUE)[,1:2]
cellphonedb = read.csv('data/cellphonedb/cellphonedb.csv', stringsAsFactors=FALSE, header=TRUE)[,1:2]
baderlab = read.csv('data/baderlab/baderlab.csv', stringsAsFactors=FALSE, header=TRUE)[,1:2]
singlecellsignalr = read.table('data/singlecellsignalr/lrdb.csv', stringsAsFactors=FALSE, skip=1, sep=",", col.names = paste0("V",seq_len(13)), fill=TRUE)[,1:2]
colnames(singlecellsignalr) <- c("GENEID_L", "GENEID_R")

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