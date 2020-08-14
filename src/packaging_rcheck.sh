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
abbr=`grep $1 sample_sheet.csv | awk -F ',' '{print $2}'`
echo $abbr

cd rpackages
ZipFile=LRBase.$abbr.eg.db_$2.tar.gz
R CMD check --no-vignettes --timings --no-multiarch $ZipFile

CheckFile=LRBase.$abbr.eg.db.Rcheck/00check.log
check=`grep -e WARNING -e ERROR $CheckFile | wc -l`

if [ $check = 0 ]; then
	echo No WARNING and No ERROR
touch ../$3
else
	echo There are some WARNING or ERROR...
	exit 1
fi
