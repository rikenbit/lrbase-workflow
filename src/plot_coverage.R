source("src/functions.R")

# Data loading
load("data/coverage_summary.RData")

# Plot
g1 <- ggplot(gdata, aes(x = reorder(x=Name, X=-Coverage, FUN=sum), y = Coverage, fill = Type)) +
    geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + xlab("Species") + ylab("No. of L-R pairs") + theme(plot.margin= unit(c(1, 1, -1, 1), "lines"))

ggsave(file="plot/coverage.png", plot=g1,
	dpi=200, width=25.0, height=5.0)
