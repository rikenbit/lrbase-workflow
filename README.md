# lrbase-workflow
Workflow to construct [LRBase.XXX.eg.db-type](https://bioconductor.org/packages/release/data/annotation/html/LRBase.Hsa.eg.db.html) packages.

# Evidence code
## 1. Known Ligand-Receptor

- **DLRP** (only Human): XXXXX
- **IUPHAR** (only Human): XXXXX
- **Ensembl_DLRP**: XXXXX
- **Ensembl_IUPHAR**: XXXXX
- **NCBI_DLRP**: XXXXX
- **NCBI_IUPHAR**: XXXXX
- **MeSH_DLRP**: XXXXX
- **MeSH_IUPHAR**: XXXXX

## 2. Putative Ligand-Receptor

- **SPRING_SWISSPROT**: XXXXX
- **SPRING_TrEMBL**: XXXXX

# Summary
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
