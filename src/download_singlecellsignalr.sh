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

wget https://www.dropbox.com/s/w5t0qgxo8soszd4/LRdb.rda?dl=1
mv LRdb.rda?dl=1 data/singlecellsignalr/LRdb.rda
