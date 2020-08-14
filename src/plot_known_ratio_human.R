source("src/functions.R")

# Known Human L-R databases
iuphar <- read.csv('data/iuphar/iuphar.csv')
dlrp <- read.csv('data/dlrp/pre_dlrp2.csv')
hpmr <- read.csv('data/hpmr/hpmr.csv')
known <- rbind(iuphar, dlrp, hpmr)

# Human L-R databases
lrbase = read.csv('data/csv/9606.csv', stringsAsFactors=FALSE, header=TRUE)[,1:2]
fantom5 = read.csv('data/fantom5/fantom5.csv', stringsAsFactors=FALSE, header=TRUE)[,1:2]
cellphonedb = read.csv('data/cellphonedb/cellphonedb.csv', stringsAsFactors=FALSE, header=TRUE)[,1:2]
baderlab = read.csv('data/baderlab/baderlab.csv', stringsAsFactors=FALSE, header=TRUE)[,1:2]
singlecellsignalr = read.table('data/singlecellsignalr/lrdb.csv', stringsAsFactors=FALSE, skip=1, sep=",", col.names = paste0("V",seq_len(13)), fill=TRUE)[,1:2]
colnames(singlecellsignalr) <- c("GENEID_L", "GENEID_R")

# Name, Value, Type (Known/Putative)
gdata <- unlist(lapply(lrnames, function(x){
	DB <- eval(parse(text=x))
	All <- nrow(unique(DB[,1:2]))
	Match <- length(intersect(
		unique(paste(DB[,1], DB[,2])),
		unique(paste(known[,1], known[,2]))))
	c(Match, All - Match)
}))

gdata <- data.frame(
	Name=unlist(lapply(lrnames2, function(x){rep(x,2)})),
	Value=gdata,
	Type=rep(c("Known", "Putative"), 5))

# Plot
g <- ggplot(gdata, aes(x = reorder(x=Name, X=-Value, FUN=sum), y = Value, fill = Type)) +
    geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + xlab("L-R databases") + ylab("No. of L-R pairs") + theme(plot.margin= unit(c(1, 1, -1, 1), "lines"))

ggsave(file='plot/known_ratio_human.png', plot=g,
	dpi=500, width=10.0, height=5.0)