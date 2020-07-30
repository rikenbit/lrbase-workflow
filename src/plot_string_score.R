source("src/functions.R")

args = commandArgs(trailingOnly=TRUE)

dbs <- sapply(args, function(x){
	target <- grep("swissprot_string", x)
	if(length(target) != 0){
		"SWISSPROT_STRING"
	}else{
		"TREMBL_STRING"
	}
})

orgs <- sapply(args, function(x){
	gsub("_v", "", str_extract(x, "\\d*_v"))
})

pairs <- sapply(args, function(x){
	data = try(read.csv(x), silent=TRUE)
	if(class(data) != "try-error"){
		nrow(data)
	}else{
		0
	}
})

types <- sapply(args, function(x){
	gsub(".csv", "", str_extract(x, "[low,mid,high]*.csv"))
})

df <- data.frame(
	Database=dbs,
	Organisms=orgs,
	Pairs=pairs,
	Types=types,
	stringsAsFactors=FALSE)
rownames(df) <- NULL

df[which(df$Organisms == 9606), "Organisms"] <- "Homo sapiens (9606)"
df[which(df$Organisms == 10090), "Organisms"] <- "Mus musculus (10090)"
df[which(df$Organisms == 3702), "Organisms"] <- "Arabidopsis thaliana (3702)"
df[which(df$Organisms == 10116), "Organisms"] <- "Rattus norvegicus (10116)"
df[which(df$Organisms == 9913), "Organisms"] <- "Bos taurus (9913)"
df[which(df$Organisms == 6239), "Organisms"] <- "Caenorhabditis elegans (6239)"
df[which(df$Organisms == 7227), "Organisms"] <- "Drosophila melanogaster (7227)"
df[which(df$Organisms == 7955), "Organisms"] <- "Danio rerio (7955)"
df[which(df$Organisms == 9031), "Organisms"] <- "Gallus gallus (9031)"
df[which(df$Organisms == 9601), "Organisms"] <- "Pongo abelii (9601)"
df[which(df$Organisms == 8364), "Organisms"] <- "Xenopus tropicalis (9606)"
df[which(df$Organisms == 9823), "Organisms"] <- "Sus scrofa (9823)"

df1 <- df[which(df$Database == "SWISSPROT_STRING"), 2:4]
df2 <- df[which(df$Database == "TREMBL_STRING"), 2:4]
organisms <- unique(df$Organisms)

df1 <- t(sapply(organisms, function(x){
	low <- intersect(
		which(df1$Organisms == x),
		which(df1$Types == "low"))
	mid <- intersect(
		which(df1$Organisms == x),
		which(df1$Types == "mid"))
	high <- intersect(
		which(df1$Organisms == x),
		which(df1$Types == "high"))
	df1[c(low,mid,high),2]
}))
colnames(df1) <- c("Low (>=150)", "Mid (>=400)", "High (>=700)")

df2 <- t(sapply(organisms, function(x){
	low <- intersect(
		which(df2$Organisms == x),
		which(df2$Types == "low"))
	mid <- intersect(
		which(df2$Organisms == x),
		which(df2$Types == "mid"))
	high <- intersect(
		which(df2$Organisms == x),
		which(df2$Types == "high"))
	df2[c(low,mid,high),2]
}))
colnames(df2) <- c("Low (>=150)", "Mid (>=400)", "High (>=700)")

# Plot
dforder <- order(df1[,3], decreasing=TRUE)
df1 <- df1[dforder, ]
df2 <- df2[dforder, ]
g1 <- gridExtra::tableGrob(df1)
g2 <- gridExtra::tableGrob(df2)

png(file='plot/swissprot_string_score.png', height=700, width=500)
grid.draw(g1)
dev.off()

png(file='plot/trembl_string_score.png', height=700, width=500)
grid.draw(g2)
dev.off()
