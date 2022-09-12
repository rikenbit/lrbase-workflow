dir.create('/tmp/libs')
.libPaths('/tmp/libs')
BiocManager::valid()
BiocManager::install(c("AnnotationHub","XML", "AnnotationHubData", "LRBaseDbi"), ask=FALSE, force=TRUE)

library("AnnotationHubData")
input = commandArgs(trailingOnly=TRUE)[1]
output = commandArgs(trailingOnly=TRUE)[2]

df <- read.table(input, skip=1, sep=",")
result <- apply(df,1, function(x){return (is.null(checkSpeciesTaxId(as.numeric(x[9]),x[8])))})

summary(result)
result

# if there is FALSE 
if ( sum(result==FALSE) > 0 ) {
    stop("At least one species taxid is wrong.")
}
# Output
file.create(output)
