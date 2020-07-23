# lrbase-workflow
Workflow to construct [LRBase.XXX.eg.db-type](https://bioconductor.org/packages/release/data/annotation/html/LRBase.Hsa.eg.db.html) packages.

![](https://github.com/rikenbit/lrbase-workflow/blob/master/dag.svg)

# Evidence code
## 1. Known Ligand-Receptor (Human)

- **DLRP**: L-R list in [DLRP](http://dip.doe-mbi.ucla.edu/dip/dlrp/dlrp.txt) database
- **IUPHAR**: L-R list in [IUPHAR](http://www.guidetopharmacology.org/DATA/interactions.csv) database

## 2. Known Ligand-Receptor (other species)

- **Ensembl_DLRP**: L-R list in [DLRP](http://dip.doe-mbi.ucla.edu/dip/dlrp/dlrp.txt) based on the ortholog of Human genes in [Ensembl Protein trees](https://asia.ensembl.org/info/genome/compara/homology_method.html)
- **Ensembl_IUPHAR**: L-R list in [IUPHAR](http://www.guidetopharmacology.org/DATA/interactions.csv) based on the ortholog of Human genes in [Ensembl Protein trees](https://asia.ensembl.org/info/genome/compara/homology_method.html)
- **NCBI_DLRP**: L-R list in [DLRP](http://dip.doe-mbi.ucla.edu/dip/dlrp/dlrp.txt) based on the ortholog of Human genes in [NCBI Homologene](https://www.ncbi.nlm.nih.gov/homologene)
- **NCBI_IUPHAR**: L-R list in [IUPHAR](http://www.guidetopharmacology.org/DATA/interactions.csv) based on the ortholog of Human genes in [NCBI Homologene](https://www.ncbi.nlm.nih.gov/homologene)
- **RBBH_DLRP**: L-R list in [DLRP](http://dip.doe-mbi.ucla.edu/dip/dlrp/dlrp.txt) based on the ortholog of Human genes in [Reciprocal BLAST Best Hit used in MeSH.XXX.eg.db workflow](https://github.com/rikenbit/meshr-pipeline)
- **RBBH_IUPHAR**: L-R list in [IUPHAR](http://www.guidetopharmacology.org/DATA/interactions.csv) based on the ortholog of Human genes in [Reciprocal BLAST Best Hit used in MeSH.XXX.eg.db workflow](https://github.com/rikenbit/meshr-pipeline)

## 3. Putative Ligand-Receptor

- **SPRING_SWISSPROT**: PPI list in [SPRING](https://string-db.org/cgi/download.pl) and known subcellular localization in [SWISSPROT](http://www.uniprot.org/uniprot/?query=reviewed:yes)
- **SPRING_TrEMBL**: PPI list in [SPRING](https://string-db.org/cgi/download.pl) and predicted subcellular localization in [TrEMBL](http://www.uniprot.org/uniprot/?query=reviewed:no)

# Summary
![](https://github.com/rikenbit/lrbase-workflow/blob/master/plot/coverage.png)

![](https://github.com/rikenbit/lrbase-workflow/blob/master/plot/percentage.png)

# How to reproduce this workflow
## 1. Prepare following datasets
- data/rbbh/*.txt: Download from [meshr-pipeline/data/RBBH/*.txt](https://github.com/rikenbit/meshr-pipeline)

## 2. Perform snakemake command

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

# License
Copyright (c) 2020 Koki Tsuyuzaki and RIKEN Bioinformatics Research Unit Released under the [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

# Authors
- Koki Tsuyuzaki
- Manabu Ishii
- Itoshi Nikaido