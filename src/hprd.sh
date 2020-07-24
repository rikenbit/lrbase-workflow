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

wget http://hprd.org/edownload/HPRD_Release9_041310 -P data/hprd
mv data/hprd/HPRD_Release9_041310 data/hprd/HPRD_Release9_041310.tar
tar -xvf data/hprd/HPRD_Release9_041310.tar -C data/hprd