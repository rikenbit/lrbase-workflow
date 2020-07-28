#!/bin/bash
#$ -l nc=24
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --nice=50
#SBATCH --requeue
#SBATCH -p node03-06
SLURM_RESTART_COUNT=2

echo $@
julia=`ls .snakemake/conda/*/bin/julia`
$julia src/preprocess_trembl.jl $@