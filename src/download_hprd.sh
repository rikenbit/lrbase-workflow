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

wget https://zenodo.org/records/10677256/files/HPRD_Release9_041310.tar -P data/hprd
tar -xvf data/hprd/HPRD_Release9_041310.tar -C data/hprd
