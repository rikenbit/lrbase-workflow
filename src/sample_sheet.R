source("src/functions.R")

# Data loading
load("data/percentage_summary.RData")

# Filtering
target <- which(gdata$Percentage != 0)
sample_sheet <- gdata[target, ]

# Ouput
write.csv(sample_sheet, "id/lrbase/sample_sheet.csv",
	quote=FALSE, row.names=FALSE)
