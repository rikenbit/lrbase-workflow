source("src/functions.R")

lrbase <- read.csv('data/csv/9606.csv', stringsAsFactors=FALSE, header=TRUE)

# Known
target.known <- which(lrbase$SOURCEDB %in% c("IUPHAR", "DLRP", "HPMR"))
known <- lrbase[target.known, ]

# Newly Known
target.newly.known <- setdiff(which(lrbase$SOURCEDB %in% c("CELLPHONEDB", "SINGLECELLSIGNALR")),
	target.known)
newly.known <- lrbase[target.newly.known, ]

# Putative
target.putative <- setdiff(seq(nrow(lrbase)), union(target.known, target.newly.known))
putative <- lrbase[target.putative, ]

# Each databases
fantom5 = lrbase[which(lrbase$SOURCEDB == "FANTOM5"), ]
cellphonedb = lrbase[which(lrbase$SOURCEDB == "CELLPHONEDB"), ]
baderlab = lrbase[which(lrbase$SOURCEDB == "BADERLAB"), ]
singlecellsignalr = lrbase[which(lrbase$SOURCEDB == "SINGLECELLSIGNALR"), ]

# Name, Value, Type (Known/Putative)
gdata <- unlist(lapply(lrnames, function(x){
	DB <- eval(parse(text=x))
	Match1 <- length(intersect(
		unique(paste(DB[,1], DB[,2])),
		unique(paste(known[,1], known[,2]))))
	Match2 <- length(intersect(
		unique(paste(DB[,1], DB[,2])),
		unique(paste(newly.known[,1], newly.known[,2]))))
	Match3 <- length(intersect(
		unique(paste(DB[,1], DB[,2])),
		unique(paste(putative[,1], putative[,2]))))
	c(Match1, Match2, Match3)
}))

gdata <- data.frame(
	Name=unlist(lapply(lrnames2, function(x){rep(x,3)})),
	Value=gdata,
	Type=rep(c("Known L-R pairs (DLRP/IUPHAR/HPMR)", "Newly Known L-R pairs (CellPhoneDB/SingleCellSignalR)", "Putative L-R pairs"), 5))

gdata2 <- gdata
gdata2$Value <- unlist(lapply(unique(as.character(gdata$Name)), function(x){
	tmp <- gdata[which(gdata$Name == x), ]
	100 * tmp$Value / sum(tmp$Value)
}))

# Order Fix
LRNames <- c("LRBase.Hsa.eg.db", "BaderLab",
	"SingleCellSignalR", "FANTOM5", "CellPhoneDB")
gdata$Name <- factor(gdata$Name, levels=LRNames)
gdata2$Name <- factor(gdata2$Name, levels=LRNames)

# Plot
g <- ggplot(gdata, aes(x = Name, y = Value, fill = Type)) +
    geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + xlab("L-R databases") + ylab("No. of L-R pairs") + theme(plot.margin= unit(c(1, 1, -1, 1), "lines"))

g2 <- ggplot(gdata2, aes(x = Name, y = Value, fill = Type)) +
    geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + xlab("L-R databases") + ylab("Percentage (%)") + theme(plot.margin= unit(c(1, 1, -1, 1), "lines"))

ggsave(file='plot/known_ratio_human.png', plot=g,
	dpi=500, width=10.0, height=5.0)

ggsave(file='plot/known_ratio_human_percentage.png', plot=g2,
	dpi=500, width=10.0, height=5.0)