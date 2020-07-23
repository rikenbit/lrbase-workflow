source("src/functions.R")

# Data loading
load("data/percentage_summary.RData")

# Plot
g1 <- ggplot(gdata, aes(x = reorder(x=Name, X=-Percentage, FUN=sum), y = Percentage, fill = Type)) +
    geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + xlab("Species") + ylab("Total percentage (0 - 400)") + theme(plot.margin= unit(c(1, 1, -1, 1), "lines"))

ggsave(file="plot/percentage.png", plot=g1,
	dpi=200, width=25.0, height=5.0)
