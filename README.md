# lrbase-summary
Selection procedure of species used in LRBase.XXX.eg.db


![](https://github.com/rikenbit/lrbase-summary/blob/master/plot/coverage.png)

![](https://github.com/rikenbit/lrbase-summary/blob/master/plot/percentage.png)

# How to perform this workflow

```
snakemake -j 4 --use-conda
```

```
snakemake -j 32 --cluster qsub --latency-wait 2000 --use-conda
```

```
snakemake -j 32 --cluster sbatch --latency-wait 2000 --use-conda
```
