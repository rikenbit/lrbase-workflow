options(scipen=100)

#################################
# PPI
#################################
STRING_PPI <- 1:12
names(STRING_PPI) <- rev(c("2019", "2018", "2017", "2016", "2015", "2013", "2011", "2010", "2009", "2008", "2007", "2005"))

STRING_PPI["2019"] <- 3123056667
STRING_PPI["2018"] <- 1380838440
STRING_PPI["2017"] <- 1380838440
STRING_PPI["2016"] <- 932553897
STRING_PPI["2015"] <- 932553897
STRING_PPI["2013"] <- 224346017
STRING_PPI["2011"] <- 89236924
STRING_PPI["2010"] <- 88633860
STRING_PPI["2009"] <- 78001069
STRING_PPI["2008"] <- 38573579
STRING_PPI["2007"] <- 12014052
STRING_PPI["2005"] <- 17804284
Year <- c(2005, 2007:2011, 2013, 2015:2019)

png(file="plot/string_ppi.png", width=700, height=500)
par(ps=28)
par(mar=c(5,12,4,2))
plot(Year, STRING_PPI, type="b", col="red", las=1,
	ylab="", lwd=2,
	ylim=c(0, max(STRING_PPI)),
	main="STRING (# PPIs)")
dev.off()

#################################
# Protein
#################################
STRING_Protein <- 1:14
names(STRING_Protein) <- rev(c("2019", "2018", "2017", "2016", "2015", "2013", "2011", "2010", "2009", "2008", "2007", "2005", "2004", "2003"))

STRING_Protein["2019"] <- 24584628
STRING_Protein["2018"] <- 9643763
STRING_Protein["2017"] <- 9643763
STRING_Protein["2016"] <- 9643763
STRING_Protein["2015"] <- 5214234
STRING_Protein["2013"] <- 5214234
STRING_Protein["2011"] <- 2590259
STRING_Protein["2010"] <- 2590259
STRING_Protein["2009"] <- 2483276
STRING_Protein["2008"] <- 1513782
STRING_Protein["2007"] <- 736429
STRING_Protein["2005"] <- 444238
STRING_Protein["2004"] <- 356775
STRING_Protein["2003"] <- 261033

Year <- c(2003:2005, 2007:2011, 2013, 2015:2019)
png(file="plot/string_protein.png", width=700, height=500)
par(ps=28)
par(mar=c(5,12,4,2))
plot(Year, STRING_Protein, type="b", col="orange", las=1,
	ylab="", lwd=2,
	ylim=c(0, max(STRING_Protein)),
	main="STRING (# Proteins)")
dev.off()

# v9.1 => Latest (v11.0)
(2.45 * 10^9) / (5.21 * 10^8)

# ref
# https://string-db.org/cgi/access.pl?footer_active_subpage=archive