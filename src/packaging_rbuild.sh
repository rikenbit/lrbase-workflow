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
PackageDir=LRBase.$abbr.eg.db
ZipFile=LRBase.$abbr.eg.db_$2.tar.gz
R CMD build --keep-empty-dirs --no-resave-data $PackageDir

if [ -f $ZipFile ]; then
	echo $ZipFile are saved in rpackages
	touch ../$3
else
	echo $ZipFile not found...
	exit 1
fi
