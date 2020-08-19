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

wget --no-check-certificate https://www.dropbox.com/s/66fw400bmoab89a/interactions_cellphonedb.csv?dl=1
mv interactions_cellphonedb.csv?dl=1 data/cellphonedb/interactions_cellphonedb.csv

wget --no-check-certificate https://www.dropbox.com/s/0l7oykri87wpr0x/heterodimers.csv?dl=1
mv heterodimers.csv?dl=1 data/cellphonedb/heterodimers.csv