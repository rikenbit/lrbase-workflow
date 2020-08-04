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
Rscript=`ls .snakemake/conda/*/bin/Rscript`
$Rscript src/preprocess_ensembl_iuphar.R $@
