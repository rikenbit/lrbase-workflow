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
abbr=(`awk -F ',' '{print $2,$5}' sample_sheet.csv | grep $1`)
abbr=${abbr[0]}
echo $abbr

ZipFile=rpackages/LRBase.$abbr.eg.db_$2.tar.gz
OutDir=reports/$1_$2

R -e "dir.create('~/libs');
.libPaths('~/libs');
install.packages('"$ZipFile"', repos=NULL, type='source');
library(scTensor);
library(SingleCellExperiment);
library(AnnotationDbi);
library(LRBase."$abbr".eg.db);
data(GermMale);
data(labelGermMale);
data(tsneGermMale);
LR <- unique(unlist(select(LRBase."$abbr".eg.db, columns=c('GENEID_L', 'GENEID_R'), keys=keys(LRBase."$abbr".eg.db, keytype='SOURCEDB'), keytype='SOURCEDB')));
Fake_GermMale <- GermMale;
m <- min(length(LR), nrow(Fake_GermMale));
set.seed(1234);
rownames(Fake_GermMale)[sample(m, m)] <- sample(LR, m);
sce <- SingleCellExperiment(assays = list(counts = Fake_GermMale));
reducedDims(sce) <- SimpleList(TSNE=tsneGermMale\$Y);
cellCellSetting(sce, LRBase."$abbr".eg.db, names(labelGermMale));
cellCellDecomp(sce, ranks=c(2,3));
cellCellReport(sce, reducedDimNames='TSNE', out.dir='"$OutDir"', title='Fake single-cell data (LRBase."$abbr".eg.db)', author='Koki Tsuyuzaki', upper=2)"