options(scipen=100)

TrEMBL <- 2010:2020
names(TrEMBL) <- 2010:2020
TrEMBL["2020"] <- 177754527
TrEMBL["2019"] <- 139694261
TrEMBL["2018"] <- 107627435
TrEMBL["2017"] <- 73711881
TrEMBL["2016"] <- 59718159
TrEMBL["2015"] <- 90860905
TrEMBL["2014"] <- 51616950
TrEMBL["2013"] <- 29266939
TrEMBL["2012"] <- 19434245
TrEMBL["2011"] <- 13069501
TrEMBL["2010"] <- 10618387
Year <- 2010:2020

png(file="plot/trembl.png", width=700, height=500)
par(ps=28)
par(mar=c(5,12,4,2))
plot(Year, TrEMBL, type="b", col="darkgreen", las=1,
	ylab="", lwd=2,
	ylim=c(0, max(TrEMBL)),
	main="TrEMBL (# Sequence Entries)")
dev.off()

# 2014 => Latest
(1.77 * 10^8) / (5.16 * 10^7)


# ref
# https://www.uniprot.org/statistics/