#!/bin/bash
#$ -l nc=24
#$ -p -50
#$ -r yes
#$ -q large.q

#SBATCH -n 4
#SBATCH --nice=50
#SBATCH --requeue
#SBATCH -p node03-06
SLURM_RESTART_COUNT=2

export LC_ALL=C

echo $@
Rscript src/packaging_rpack.R $@

abbr=`grep $3 sample_sheet.csv | awk -F ',' '{print $2}'`
echo $abbr

PackageDir=rpackages/LRBase.$abbr.eg.db
if [ -d $PackageDir ]; then
	echo $PackageDir are saved in rpackages
	touch $5
else
	echo $PackageDir not found...
	exit 1
fi
