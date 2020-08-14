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

export LC_ALL=C

echo $@
abbr=`grep $1 sample_sheet.csv | awk -F ',' '{print $2}'`
echo $abbr

ZipFile=rpackages/LRBase.$abbr.eg.db_$2.tar.gz
OutDir=reports/$1_$2

R -e "install.packages('"$ZipFile"', repos=NULL, type='source');
library(scTensor);
library(SingleCellExperiment);
library(LRBase."$abbr".eg.db);
try(library(MeSH."$abbr".eg.db));
data(GermMale);
data(labelGermMale);
data(tsneGermMale);
LR <- unique(unlist(select(LRBase."$abbr".eg.db, columns=c('GENEID_L', 'GENEID_R'), keys=keys(LRBase."$abbr".eg.db, keytype='SOURCEDB'), keytype='SOURCEDB')));
Fake_GermMale <- GermMale;
m <- min(length(LR), nrow(Fake_GermMale));
rownames(Fake_GermMale)[sample(m, m)] <- sample(LR, m);
sce <- SingleCellExperiment(assays = list(counts = Fake_GermMale));
reducedDims(sce) <- SimpleList(TSNE=tsneGermMale\$Y);
cellCellSetting(sce, LRBase."$abbr".eg.db, labelGermMale, names(labelGermMale));
cellCellDecomp(sce, ranks=c(4,4,10));
cellCellReport(sce, reducedDimNames='TSNE', out.dir='"$OutDir"', title='Fake single-cell data', author='Koki Tsuyuzaki', thr=20)"