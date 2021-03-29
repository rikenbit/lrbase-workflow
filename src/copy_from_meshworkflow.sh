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

ARRAY=(`tail -n 114 sample_sheet/114.csv | awk -F ',' '{print $2}'`)
COUNT=0
for i in ${ARRAY[@]}; do
	COUNT=`expr $COUNT + 1`
	echo "$COUNT / ${#ARRAY[@]}"
	cp ../mesh-workflow/output/rbbh/$i.txt data/rbbh/
done
