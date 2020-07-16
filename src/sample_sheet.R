source("src/functions.R")

# Data loading
load("data/percentage_summary.RData")

# Filtering
target1 <- which(gdata$Type == "Ensembl_IUPHAR")
target2 <- which(gdata$Percentage >= 50.0)
target <- intersect(target1, target2)
sample_sheet <- gdata[target, ]

# Ouput
write.csv(sample_sheet, "sample_sheet.csv",
	quote=FALSE, row.names=FALSE)
