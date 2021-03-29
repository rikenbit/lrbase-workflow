# Command line arguments
library("AnnotationHubData")
input = commandArgs(trailingOnly=TRUE)[1]
output = commandArgs(trailingOnly=TRUE)[2]

# check
makeAnnotationHubMetadata(input)

# Output
file.create(output)
