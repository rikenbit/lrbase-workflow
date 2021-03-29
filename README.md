# lrbase-workflow
Workflow to construct [LRBase.XXX.eg.db-type](https://bioconductor.org/packages/release/data/annotation/html/LRBase.Hsa.eg.db.html) packages.

# Pre-requisites
- Bash: GNU bash, version 4.2.46(1)-release (x86_64-redhat-linux-gnu)
- Snakemake: 5.3.0
- Singularity: 3.5.3

# Summary
![](https://github.com/rikenbit/lrbase-workflow/blob/master/plot/summary.png)
![](https://github.com/rikenbit/lrbase-workflow/blob/master/plot/known_ratio.png)
![](https://github.com/rikenbit/lrbase-workflow/blob/master/plot/summary_percentage.png)
![](https://github.com/rikenbit/lrbase-workflow/blob/master/plot/known_ratio_percentage.png)

# Evidence code
## 1. Known Ligand-Receptor (only human)

- **DLRP**: L-R list in [DLRP](http://dip.doe-mbi.ucla.edu/dip/dlrp/dlrp.txt) database
- **IUPHAR**: L-R list in [IUPHAR](http://www.guidetopharmacology.org/DATA/interactions.csv) database
- **HPMR**: L-R list in [HPMR](http://www.receptome.org) database
- **CELLPHONEDB**: L-R list in [CellPhoneDB](https://www.cellphonedb.org) database
- **SINGLECELLSIGNALR**: L-R list in [SingleCellSignalR](https://bioconductor.org/packages/release/bioc/html/SingleCellSignalR.html) database

## 2. Known Ligand-Receptor (other species, ortholog based)

- **ENSEMBL_DLRP**: L-R list in [DLRP](http://dip.doe-mbi.ucla.edu/dip/dlrp/dlrp.txt) based on the ortholog of Human genes in [Ensembl Protein trees](https://asia.ensembl.org/info/genome/compara/homology_method.html)
- **ENSEMBL_IUPHAR**: L-R list in [IUPHAR](http://www.guidetopharmacology.org/DATA/interactions.csv) based on the ortholog of Human genes in [Ensembl Protein trees](https://asia.ensembl.org/info/genome/compara/homology_method.html)
- **ENSEMBL_HPMR**: L-R list in [HPMR](http://www.receptome.org) based on the ortholog of Human genes in [Ensembl Protein trees](https://asia.ensembl.org/info/genome/compara/homology_method.html)
- **ENSEMBL_CELLPHONEDB**: L-R list in [CellPhoneDB](https://www.cellphonedb.org) database based on the ortholog of Human genes in [Ensembl Protein trees](https://asia.ensembl.org/info/genome/compara/homology_method.html)
- **ENSEMBL_SINGLECELLSIGNALR**: L-R list in [SingleCellSignalR](https://bioconductor.org/packages/release/bioc/html/SingleCellSignalR.html) database based on the ortholog of Human genes in [Ensembl Protein trees](https://asia.ensembl.org/info/genome/compara/homology_method.html)
- **NCBI_DLRP**: L-R list in [DLRP](http://dip.doe-mbi.ucla.edu/dip/dlrp/dlrp.txt) based on the ortholog of Human genes in [NCBI Homologene](https://www.ncbi.nlm.nih.gov/homologene)
- **NCBI_IUPHAR**: L-R list in [IUPHAR](http://www.guidetopharmacology.org/DATA/interactions.csv) based on the ortholog of Human genes in [NCBI Homologene](https://www.ncbi.nlm.nih.gov/homologene)
- **NCBI_HPMR**: L-R list in [HPMR](http://www.receptome.org) based on the ortholog of Human genes in [NCBI Homologene](https://www.ncbi.nlm.nih.gov/homologene)
- **NCBI_CELLPHONEDB**: L-R list in [CellPhoneDB](https://www.cellphonedb.org) database based on the ortholog of Human genes in [NCBI Homologene](https://www.ncbi.nlm.nih.gov/homologene)
- **NCBI_SINGLECELLSIGNALR**: L-R list in [SingleCellSignalR](https://bioconductor.org/packages/release/bioc/html/SingleCellSignalR.html) database based on the ortholog of Human genes in [NCBI Homologene](https://www.ncbi.nlm.nih.gov/homologene)
- **RBBH_DLRP**: L-R list in [DLRP](http://dip.doe-mbi.ucla.edu/dip/dlrp/dlrp.txt) based on the ortholog of Human genes in [Reciprocal BLAST Best Hit used in MeSH.XXX.eg.db workflow](https://github.com/rikenbit/meshr-pipeline)
- **RBBH_IUPHAR**: L-R list in [IUPHAR](http://www.guidetopharmacology.org/DATA/interactions.csv) based on the ortholog of Human genes in [Reciprocal BLAST Best Hit used in MeSH.XXX.eg.db workflow](https://github.com/rikenbit/meshr-pipeline)
- **RBBH_HPMR**: L-R list in [HPMR](http://www.receptome.org) based on the ortholog of Human genes in [Reciprocal BLAST Best Hit used in MeSH.XXX.eg.db workflow](https://github.com/rikenbit/meshr-pipeline)
- **RBBH_CELLPHONEDB**: L-R list in [CellPhoneDB](https://www.cellphonedb.org) database based on the ortholog of Human genes in [Reciprocal BLAST Best Hit used in MeSH.XXX.eg.db workflow](https://github.com/rikenbit/meshr-pipeline)
- **RBBH_SINGLECELLSIGNALR**: L-R list in [SingleCellSignalR](https://bioconductor.org/packages/release/bioc/html/SingleCellSignalR.html) database based on the ortholog of Human genes in [Reciprocal BLAST Best Hit used in MeSH.XXX.eg.db workflow](https://github.com/rikenbit/meshr-pipeline)

## 3. Putative Ligand-Receptor (only human)

- **SWISSPROT_HPRD**: Known subcellular localization in [Swiss-Prot](http://www.uniprot.org/uniprot/?query=reviewed:yes) and PPI list in [HPRD](http://hprd.org/download)
- **TREMBL_HPRD**: Predicted subcellular localization in [TrEMBL](http://www.uniprot.org/uniprot/?query=reviewed:no) and PPI list in [HPRD](http://hprd.org/download)
- **FANTOM5**: Predicted L-R list used in the [FANTOM5 project](https://fantom.gsc.riken.jp/5/suppl/Ramilowski_et_al_2015/)
- **BADERLAB**: Predicted L-R list used in the [Bader Lab](https://baderlab.org/CellCellInteractions)

## 4. Putative Ligand-Receptor (other species, ortholog based)

- **ENSEMBL_SWISSPROT_HPRD**: Known subcellular localization in [Swiss-Prot](http://www.uniprot.org/uniprot/?query=reviewed:yes) and PPI list in [HPRD](http://hprd.org/download) based on the ortholog of Human genes in [Ensembl Protein trees](https://asia.ensembl.org/info/genome/compara/homology_method.html)
- **ENSEMBL_TREMBL_HPRD**: Predicted subcellular localization in [TrEMBL](http://www.uniprot.org/uniprot/?query=reviewed:no) and PPI list in [HPRD](http://hprd.org/download) based on the ortholog of Human genes in [Ensembl Protein trees](https://asia.ensembl.org/info/genome/compara/homology_method.html)
- **ENSEMBL_FANTOM5**: Predicted L-R list used in the [FANTOM5 project](https://fantom.gsc.riken.jp/5/suppl/Ramilowski_et_al_2015/) based on the ortholog of Human genes in [Ensembl Protein trees](https://asia.ensembl.org/info/genome/compara/homology_method.html)
- **ENSEMBL_BADERLAB**: Predicted L-R list used in the [Bader Lab](https://baderlab.org/CellCellInteractions) based on the ortholog of Human genes in [Ensembl Protein trees](https://asia.ensembl.org/info/genome/compara/homology_method.html)
- **NCBI_SWISSPROT_HPRD**: Known subcellular localization in [Swiss-Prot](http://www.uniprot.org/uniprot/?query=reviewed:yes) and PPI list in [HPRD](http://hprd.org/download) based on the ortholog of Human genes in [NCBI Homologene](https://www.ncbi.nlm.nih.gov/homologene)
- **NCBI_TREMBL_HPRD**: Predicted subcellular localization in [TrEMBL](http://www.uniprot.org/uniprot/?query=reviewed:no) and PPI list in [HPRD](http://hprd.org/download) based on the ortholog of Human genes in [NCBI Homologene](https://www.ncbi.nlm.nih.gov/homologene)
- **NCBI_FANTOM5**: Predicted L-R list used in the [FANTOM5 project](https://fantom.gsc.riken.jp/5/suppl/Ramilowski_et_al_2015/) based on the ortholog of Human genes in [NCBI Homologene](https://www.ncbi.nlm.nih.gov/homologene)
- **NCBI_BADERLAB**: Predicted L-R list used in the [Bader Lab](https://baderlab.org/CellCellInteractions) based on the ortholog of Human genes in [NCBI Homologene](https://www.ncbi.nlm.nih.gov/homologene)
- **RBBH_SWISSPROT_HPRD**: Known subcellular localization in [Swiss-Prot](http://www.uniprot.org/uniprot/?query=reviewed:yes) and PPI list in [HPRD](http://hprd.org/download) based on the ortholog of Human genes in [Reciprocal BLAST Best Hit used in MeSH.XXX.eg.db workflow](https://github.com/rikenbit/meshr-pipeline)
- **RBBH_TREMBL_HPRD**: Predicted subcellular localization in [TrEMBL](http://www.uniprot.org/uniprot/?query=reviewed:no) and PPI list in [HPRD](http://hprd.org/download) based on the ortholog of Human genes in [Reciprocal BLAST Best Hit used in MeSH.XXX.eg.db workflow](https://github.com/rikenbit/meshr-pipeline)
- **RBBH_FANTOM5**: Predicted L-R list used in the [FANTOM5 project](https://fantom.gsc.riken.jp/5/suppl/Ramilowski_et_al_2015/) based on the ortholog of Human genes in [Reciprocal BLAST Best Hit used in MeSH.XXX.eg.db workflow](https://github.com/rikenbit/meshr-pipeline)
- **RBBH_BADERLAB**: Predicted L-R list used in the [Bader Lab](https://baderlab.org/CellCellInteractions) based on the ortholog of Human genes in [Reciprocal BLAST Best Hit used in MeSH.XXX.eg.db workflow](https://github.com/rikenbit/meshr-pipeline)

## 5. Putative Ligand-Receptor (all species)

- **SWISSPROT_SPRING**: Known subcellular localization in [Swiss-Prot](http://www.uniprot.org/uniprot/?query=reviewed:yes) and PPI list in [SPRING](https://string-db.org/cgi/download.pl)
- **TREMBL_SPRING**: Predicted subcellular localization in [TrEMBL](http://www.uniprot.org/uniprot/?query=reviewed:no) and PPI list in [SPRING](https://string-db.org/cgi/download.pl)

# How to reproduce this workflow
## 1. Configuration
- data/rbbh/*.txt: Download from [mesh-workflow/output/rbbh/*.txt](https://github.com/rikenbit/mesh-workflow) and set them to data/rbbh/ directory.
- sample_sheet/100.csv: Download from [mesh-workflow/sample_sheet/100.csv](https://github.com/rikenbit/meshr-workflow) and set them as sample_sheet/100.csv.
- config.yaml: Check the latest version of STRING database (e.g., v11.0 on 2021/3/26 https://string-db.org) and change the value of VERSION_STRING, if it is needed. Also, specify the version of LRBase to crate.

## 2. Perform snakemake command
The workflow consists of two snakemake workflows.
After performing workflow/workflow1.smk, perform workflow/workflow2.smk as follows.

In local machine:
```
snakemake -s workflow/download.smk -j 4 --use-singularity
snakemake -s workflow/preprocess_known_human.smk -j 4 --use-singularity
snakemake -s workflow/preprocess_known_otherspecies.smk -j 4 --use-singularity
snakemake -s workflow/preprocess_putative_human.smk -j 4 --use-singularity
snakemake -s workflow/preprocess_putative_otherspecies.smk -j 4 --use-singularity
snakemake -s workflow/preprocess_putative_allpecies.smk -j 4 --use-singularity
snakemake -s workflow/csv.smk -j 4 --use-singularity
snakemake -s workflow/sqlite.smk -j 4 --use-singularity
snakemake -s workflow/metadata.smk -j 4 --use-singularity
snakemake -s workflow/plot.smk -j 4 --use-singularity
```

In parallel environment (GridEngine):
```
snakemake -s workflow/download.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/preprocess_known_human.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/preprocess_known_otherspecies.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/preprocess_known_allspecies.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/preprocess_putative_human.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/preprocess_putative_otherspecies.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/csv.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/sqlite.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/metadata.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/plot.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
```

In parallel environment (Slurm):
```
snakemake -s workflow/download.smk -j 32 --cluster "sbatch -n 4 --nice=50 --requeue -p node03-06" --latency-wait 600 --use-singularity
snakemake -s workflow/preprocess_known_human.smk -j 32 --cluster "sbatch -n 4 --nice=50 --requeue -p node03-06" --latency-wait 600 --use-singularity
snakemake -s workflow/preprocess_known_otherspecies.smk -j 32 --cluster "sbatch -n 4 --nice=50 --requeue -p node03-06" --latency-wait 600 --use-singularity
snakemake -s workflow/preprocess_putative_human.smk -j 32 --cluster "sbatch -n 4 --nice=50 --requeue -p node03-06" --latency-wait 600 --use-singularity
snakemake -s workflow/preprocess_putative_otherspecies.smk -j 32 --cluster "sbatch -n 4 --nice=50 --requeue -p node03-06" --latency-wait 600 --use-singularity
snakemake -s workflow/preprocess_putative_allspecies.smk -j 32 --cluster "sbatch -n 4 --nice=50 --requeue -p node03-06" --latency-wait 600 --use-singularity
snakemake -s workflow/csv.smk -j 32 --cluster "sbatch -n 4 --nice=50 --requeue -p node03-06" --latency-wait 600 --use-singularity
snakemake -s workflow/sqlite.smk -j 32 --cluster "sbatch -n 4 --nice=50 --requeue -p node03-06" --latency-wait 600 --use-singularity
snakemake -s workflow/metadata.smk -j 32 --cluster "sbatch -n 4 --nice=50 --requeue -p node03-06" --latency-wait 600 --use-singularity
snakemake -s workflow/plot.smk -j 32 --cluster "sbatch -n 4 --nice=50 --requeue -p node03-06" --latency-wait 600 --use-singularity
```

# License
Copyright (c) 2021 Koki Tsuyuzaki and RIKEN Bioinformatics Research Unit Released under the [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

# Authors
- Koki Tsuyuzaki
- Manabu Ishii
- Itoshi Nikaido