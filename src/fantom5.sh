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

wget http://fantom.gsc.riken.jp/5/suppl/Ramilowski_et_al_2015/data/PairsLigRec.txt -P data/fantom5/
wget https://www.dropbox.com/s/dvvgudbgbhrlkud/ncomms8866-s3.xlsx?dl=1
mv ncomms8866-s3.xlsx?dl=1 data/fantom5/ncomms8866-s3.xlsx
