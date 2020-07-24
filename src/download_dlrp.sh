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

wget https://www.dropbox.com/s/f2g65zrhrf99ljb/dlrp.txt?dl=1
mv dlrp.txt?dl=1 data/dlrp/dlrp.txt
