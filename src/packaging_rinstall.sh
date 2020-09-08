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
abbr=(`awk -F ',' '{print $2,$5}' sample_sheet.csv | grep $1`)
abbr=${abbr[0]}
echo $abbr

cd rpackages
ZipFile=LRBase.$abbr.eg.db_$2.tar.gz
R CMD INSTALL $ZipFile
cd ..

$R -e "library(LRBase."$abbr".eg.db);
c <- columns(LRBase."$abbr".eg.db);
keytypes(LRBase."$abbr".eg.db);
k <- head(keys(LRBase."$abbr".eg.db, keytype='GENEID_L'));
out <- select(LRBase."$abbr".eg.db, columns=c, keytype='GENEID_L', keys=k);
dbconn(LRBase."$abbr".eg.db);
dbfile(LRBase."$abbr".eg.db);
dbschema(LRBase."$abbr".eg.db);
dbInfo(LRBase."$abbr".eg.db);
species(LRBase."$abbr".eg.db);
lrPackageName(LRBase."$abbr".eg.db);
lrNomenclature(LRBase."$abbr".eg.db);
lrListDatabases(LRBase."$abbr".eg.db);
lrVersion(LRBase."$abbr".eg.db);
print(sessionInfo())"

touch $3