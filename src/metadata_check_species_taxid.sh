#!/bin/bash
#$ -q node.q

#SBATCH -n 4
#SBATCH --nice=50
#SBATCH --requeue
#SBATCH -p node03-06
SLURM_RESTART_COUNT=2
export LC_ALL=C
# CSV Check
# 1: csv 2:  output
Rscript src/metadata_check_species_taxid.R $@
