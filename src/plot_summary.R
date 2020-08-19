source("src/functions.R")

# Data loading
load("data/summary.RData")

# Log
gdata <- gdata[which(gdata$Coverage != 0), ]

gdata2 <- gdata
sapply(unique(as.character(gdata2$Name)), function(x){
	target <- which(gdata2$Name == x)
	tmp <- gdata[target, ]
	gdata2$Coverage[target] <<- 100 * tmp$Coverage / sum(tmp$Coverage)
})

# Order Fix
orderCoverage <- order(unlist(lapply(unique(as.character(gdata$Name)), function(x){
	sum(gdata[which(gdata$Name == x), "Coverage"])
})), decreasing=TRUE)
SNames = unique(as.character(gdata$Name))[orderCoverage]
gdata$Name <- factor(gdata$Name, levels=SNames)
gdata2$Name <- factor(gdata2$Name, levels=SNames)

# Plot
g <- ggplot(gdata, aes(x = Name, y = Coverage, fill = Type)) +
    geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + xlab("Species") + ylab("No. of L-R pairs") + theme(plot.margin= unit(c(1, 1, -1, 1), "lines"))

g2 <- ggplot(gdata2, aes(x = Name, y = Coverage, fill = Type)) +
    geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + xlab("Species") + ylab("Percentage") + theme(plot.margin= unit(c(1, 1, -1, 1), "lines"))

ggsave(file="plot/summary.png", plot=g,
	dpi=500, width=40.0, height=10.0)

ggsave(file="plot/summary_percentage.png", plot=g2,
	dpi=500, width=40.0, height=10.0)