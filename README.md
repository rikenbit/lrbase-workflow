# lrbase-workflow
Workflow to construct [LRBase.XXX.eg.db-type](https://bioconductor.org/packages/release/data/annotation/html/LRBase.Hsa.eg.db.html) packages.

# Pre-requisites
- Bash: GNU bash, version 4.2.46(1)-release (x86_64-redhat-linux-gnu)
- Snakemake: 5.14.0
- Anaconda: 4.8.3
- Singularity: 3.5.3

# Evidence code
## 1. Known Ligand-Receptor (only human)

- **DLRP**: L-R list in [DLRP](http://dip.doe-mbi.ucla.edu/dip/dlrp/dlrp.txt) database
- **IUPHAR**: L-R list in [IUPHAR](http://www.guidetopharmacology.org/DATA/interactions.csv) database

## 2. Known Ligand-Receptor (all species)

- **ENSEMBL_DLRP**: L-R list in [DLRP](http://dip.doe-mbi.ucla.edu/dip/dlrp/dlrp.txt) based on the ortholog of Human genes in [Ensembl Protein trees](https://asia.ensembl.org/info/genome/compara/homology_method.html)
- **ENSEMBL_IUPHAR**: L-R list in [IUPHAR](http://www.guidetopharmacology.org/DATA/interactions.csv) based on the ortholog of Human genes in [Ensembl Protein trees](https://asia.ensembl.org/info/genome/compara/homology_method.html)
- **NCBI_DLRP**: L-R list in [DLRP](http://dip.doe-mbi.ucla.edu/dip/dlrp/dlrp.txt) based on the ortholog of Human genes in [NCBI Homologene](https://www.ncbi.nlm.nih.gov/homologene)
- **NCBI_IUPHAR**: L-R list in [IUPHAR](http://www.guidetopharmacology.org/DATA/interactions.csv) based on the ortholog of Human genes in [NCBI Homologene](https://www.ncbi.nlm.nih.gov/homologene)
- **RBBH_DLRP**: L-R list in [DLRP](http://dip.doe-mbi.ucla.edu/dip/dlrp/dlrp.txt) based on the ortholog of Human genes in [Reciprocal BLAST Best Hit used in MeSH.XXX.eg.db workflow](https://github.com/rikenbit/meshr-pipeline)
- **RBBH_IUPHAR**: L-R list in [IUPHAR](http://www.guidetopharmacology.org/DATA/interactions.csv) based on the ortholog of Human genes in [Reciprocal BLAST Best Hit used in MeSH.XXX.eg.db workflow](https://github.com/rikenbit/meshr-pipeline)

## 3. Putative Ligand-Receptor (only human)

- **SWISSPROT_HPRD**: Known subcellular localization in [Swiss-Prot](http://www.uniprot.org/uniprot/?query=reviewed:yes) and PPI list in [HPRD](http://hprd.org/download)
- **TREMBL_HPRD**: Predicted subcellular localization in [TrEMBL](http://www.uniprot.org/uniprot/?query=reviewed:no) and PPI list in [HPRD](http://hprd.org/download)


## 4. Putative Ligand-Receptor (all species)

- **SWISSPROT_SPRING**: Known subcellular localization in [Swiss-Prot](http://www.uniprot.org/uniprot/?query=reviewed:yes) and PPI list in [SPRING](https://string-db.org/cgi/download.pl)
- **TREMBL_SPRING**: Predicted subcellular localization in [TrEMBL](http://www.uniprot.org/uniprot/?query=reviewed:no) and PPI list in [SPRING](https://string-db.org/cgi/download.pl)

# Summary
![](https://github.com/rikenbit/lrbase-workflow/blob/master/plot/summary.png)
![](https://github.com/rikenbit/lrbase-workflow/blob/master/plot/venndiagram_human.png)

# How to reproduce this workflow
## 1. Configuration
- data/rbbh/*.txt: Download from [meshr-pipeline/data/RBBH/*.txt](https://github.com/rikenbit/meshr-pipeline) and set them to data/rbbh directory.
- id/mesh/{threename.txt,commonname.txt,name.txt,taxid.txt}: Download from [meshr-pipeline/data/RBBH/*.txt](https://github.com/rikenbit/meshr-pipeline) and set them to id/mesh directory.
- config.yaml: Check the latest version of STRING database (e.g., v11.0 on 2020/8/6 https://string-db.org) and change the value of VERSION_STRING.

## 2. Perform snakemake command
The workflow consists of two snakemake workflows.
After performing workflow/workflow1.smk, perform workflow/workflow2.smk as follows.

In local machine:
```
snakemake -s workflow/workflow1.smk -j 4 --use-conda
snakemake -s workflow/workflow2.smk -j 4 --use-conda
```

In parallel environment (GridEngine):
```
snakemake -s workflow/workflow1.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q large.q" --latency-wait 2000 --use-conda
snakemake -s workflow/workflow2.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q large.q" --latency-wait 2000 --use-conda
```

In parallel environment (Slurm):
```
snakemake -s workflow/workflow1.smk -j 32 --cluster "sbatch -n 4 --nice=50 --requeue -p node03-06" --latency-wait 2000 --use-conda
snakemake -s workflow/workflow2.smk -j 32 --cluster "sbatch -n 4 --nice=50 --requeue -p node03-06" --latency-wait 2000 --use-conda
```

# License
Copyright (c) 2020 Koki Tsuyuzaki and RIKEN Bioinformatics Research Unit Released under the [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

# Authors
- Koki Tsuyuzaki
- Manabu Ishii
- Itoshi Nikaido