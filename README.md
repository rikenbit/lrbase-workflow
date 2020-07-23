# lrbase-workflow
Workflow to construct LRBase.XXX.eg.db-type packages.

![](https://github.com/rikenbit/lrbase-workflow/blob/master/plot/coverage.png)

![](https://github.com/rikenbit/lrbase-workflow/blob/master/plot/percentage.png)

# How to perform this workflow

In local machine:
```
snakemake -j 4 --use-conda
```

In parallel environment (GridEngine):
```
snakemake -j 32 --cluster qsub --latency-wait 2000 --use-conda
```

In parallel environment (Slurm):
```
snakemake -j 32 --cluster sbatch --latency-wait 2000 --use-conda
```
