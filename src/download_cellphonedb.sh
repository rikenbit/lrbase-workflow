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

wget --no-check-certificate https://raw.githubusercontent.com/Teichlab/cellphonedb-data/master/data/interaction_input.csv -P data/cellphonedb/
wget --no-check-certificate https://raw.githubusercontent.com/Teichlab/cellphonedb-data/master/data/complex_input.csv -P data/cellphonedb/
