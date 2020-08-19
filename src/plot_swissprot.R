options(scipen=100)

SWISSPROT <- 2010:2020
names(SWISSPROT) <- 2010:2020
SWISSPROT["2020"] <- 561911
SWISSPROT["2019"] <- 559077
SWISSPROT["2018"] <- 556568
SWISSPROT["2017"] <- 553474
SWISSPROT["2016"] <- 550299
SWISSPROT["2015"] <- 547599
SWISSPROT["2014"] <- 542258
SWISSPROT["2013"] <- 538849
SWISSPROT["2012"] <- 534242
SWISSPROT["2011"] <- 524420
SWISSPROT["2010"] <- 516081
Year <- 2010:2020

png(file="plot/swissprot.png", width=700, height=500)
par(ps=28)
par(mar=c(5,12,4,2))
plot(Year, SWISSPROT, type="b", col="purple", las=1,
	ylab="", lwd=2,
	ylim=c(0, max(SWISSPROT)),
	main="SWISSPROT (# Sequence Entries)")
dev.off()

# 2014 => Latest
(5.61 * 10^5) / (5.47 * 10^5)

# ref
# https://www.uniprot.org/statistics/