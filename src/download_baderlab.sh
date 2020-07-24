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

wget --no-check-certificate https://www.dropbox.com/s/95mcq48j8osfno1/receptor_ligand_interactions_mitab_v1.0_April2017.txt.zip?dl=0
mv receptor_ligand_interactions_mitab_v1.0_April2017.txt.zip?dl=0 receptor_ligand_interactions_mitab_v1.0_April2017.txt.zip
zcat receptor_ligand_interactions_mitab_v1.0_April2017.txt.zip > data/baderlab/receptor_ligand_interactions_mitab_v1.0_April2017.txt
rm receptor_ligand_interactions_mitab_v1.0_April2017.txt.zip