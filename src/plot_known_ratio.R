source("src/functions.R")

sample_sheet <- read.csv("sample_sheet/sample_sheet.csv")
taxid_all <- as.character(sample_sheet[, "Taxon.ID"])
orgname_all <- as.character(sample_sheet[, "Scientific.name"])

gdata <- as.vector(sapply(taxid_all, function(x){
	filename <- paste0("data/csv/", x, ".csv")
	data <- read.csv(filename)
	# Known
	target.known1 <- grep("DLRP", data$SOURCEDB)
	target.known2 <- grep("IUPHAR", data$SOURCEDB)
	target.known3 <- grep("HPMR", data$SOURCEDB)
	target.known <- union(union(target.known1, target.known2), target.known3)
	# Newly Known
	target.newly.known1 <- grep("CELLPHONEDB", data$SOURCEDB)
	target.newly.known2 <- grep("SINGLECELLSIGNALR", data$SOURCEDB)
	target.newly.known <- unique(target.newly.known1, target.newly.known2)
	target.newly.known <- union(target.newly.known, target.known)
	# Putative
	target.putative <- setdiff(setdiff(seq(nrow(data)), target.known), target.newly.known)
	# Output
	c(length(target.known), length(target.newly.known), length(target.putative))
}))

gdata <- data.frame(
	Name=unlist(lapply(orgname_all, function(x){rep(x,3)})),
	Value=gdata,
	Type=rep(c("Known L-R pairs (DLRP/IUPHAR/HPMR)", "Newly Known L-R pairs (CellPhoneDB/SingleCellSignalR)", "Putative L-R pairs"), length(orgname_all)))

gdata2 <- gdata
gdata2$Value <- unlist(lapply(unique(as.character(gdata$Name)), function(x){
	tmp <- gdata[which(gdata$Name == x), ]
	100 * tmp$Value / sum(tmp$Value)
}))

# Order Fix
orderOrg <- order(sapply(as.character(orgname_all), function(x){
	target <- which(gdata$Name == x)
	sum(gdata$Value[target])
}), decreasing=TRUE)
gdata$Name <- factor(gdata$Name, levels=orgname_all[orderOrg])
gdata2$Name <- factor(gdata$Name, levels=orgname_all[orderOrg])

# Plot
g <- ggplot(gdata, aes(x = Name, y = Value, fill = Type)) +
    geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + xlab("L-R databases") + ylab("No. of L-R pairs") + theme(plot.margin= unit(c(1, 1, -1, 1), "lines"))

g2 <- ggplot(gdata2, aes(x = Name, y = Value, fill = Type)) +
    geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + xlab("L-R databases") + ylab("Percentage (%)") + theme(plot.margin= unit(c(1, 1, -1, 1), "lines"))

ggsave(file='plot/known_ratio.png', plot=g,
	dpi=500, width=20.0, height=5.0)

ggsave(file='plot/known_ratio_percentage.png', plot=g2,
	dpi=500, width=20.0, height=5.0)