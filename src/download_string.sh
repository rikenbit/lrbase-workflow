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

echo $@
wget "https://stringdb-static.org/download/protein.links.detailed."$1"/"$2".protein.links.detailed."$1".txt.gz" -P data/string/
gunzip data/string/$2".protein.links.detailed."$1".txt.gz"