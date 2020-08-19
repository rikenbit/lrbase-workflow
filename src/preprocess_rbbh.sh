#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q large.q

#SBATCH -n 4
#SBATCH --nice=50
#SBATCH --requeue
#SBATCH -p node03-06
SLURM_RESTART_COUNT=2

echo $@
grep "Homo sapiens" $1 | awk -v 'OFS=,' '{print $1,$4}' | sort | uniq > $2
