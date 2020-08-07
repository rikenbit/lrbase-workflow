source("src/functions.R")

# Data loading
load("data/summary.RData")

# Log
gdata <- gdata[which(gdata$Coverage != 0), ]
gdata$Coverage <- log10(gdata$Coverage + 1)

# Plot
g <- ggplot(gdata, aes(x = reorder(x=Name, X=-Coverage, FUN=sum), y = Coverage, fill = Type)) +
    geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + xlab("Species") + ylab("Log10(No. of L-R pairs+1)") + theme(plot.margin= unit(c(1, 1, -1, 1), "lines"))

ggsave(file="plot/summary.png", plot=g,
	dpi=500, width=40.0, height=10.0)
