source("src/functions.R")

org = commandArgs(trailingOnly=TRUE)[1] # 10090
v = commandArgs(trailingOnly=TRUE)[2] # v11.0
thr = as.numeric(commandArgs(trailingOnly=TRUE)[3]) # 150

infile = paste0("data/trembl_string/", org, "_", v, ".csv")
data = try(read.csv(infile))

if(class(data) != "try-error"){
	if(thr == 150){
		outfile = paste0("data/trembl_string/", org, "_", v, "_low.csv")
	}
	if(thr == 400){
		outfile = paste0("data/trembl_string/", org, "_", v, "_mid.csv")
	}
	if(thr == 700){
		outfile = paste0("data/trembl_string/", org, "_", v, "_high.csv")
	}
	# Filtering
	data = data[data$combined_score > thr, ]
	# Output
	write.csv(data, file=outfile)
}
