#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --nice=50
#SBATCH --requeue
#SBATCH -p node03-06
SLURM_RESTART_COUNT=2

export LC_ALL=C

# $1: input (csv)
# $2: metadata（csv）
# $3: output (sqlite)
echo $1
echo $2
echo $3

sqlitequery=`echo $RANDOM`.query
sed -e "s|XXXXX|$1|g" src/lrbase.query | sed -e "s|YYYYY|$2|g" > $sqlitequery
sqlite3 $3 < $sqlitequery
rm -rf $sqlitequery
