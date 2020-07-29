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

# Animal
Datasets=('hsapiens_gene_ensembl' 'mmusculus_gene_ensembl' 'rnorvegicus_gene_ensembl' 'btaurus_gene_ensembl' 'celegans_gene_ensembl' 'dmelanogaster_gene_ensembl' 'drerio_gene_ensembl' 'ggallus_gene_ensembl' 'pabelii_gene_ensembl' 'xtropicalis_gene_ensembl' 'sscrofa_gene_ensembl')
TaxID=('9606' '10090' '10116' '9913' '6239' '7227' '7955' '9031' '9601' '8364' '9823')
for ((i=0; i < ${#Datasets[@]}; i++)); do
        echo ${TaxID[$i]}
        wget -O data/ensembl/${TaxID[$i]}.txt 'http://www.ensembl.org/biomart/martservice?query=<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE Query><Query  virtualSchemaName = "default" formatter = "TSV" header = "0" uniqueRows = "0" count = "" datasetConfigVersion = "0.6" ><Dataset name = "'${Datasets[$i]}'" interface = "default" ><Attribute name = "entrezgene_id" /><Attribute name = "ensembl_peptide_id" /></Dataset></Query>'
done

# Plant
Datasets=('athaliana_eg_gene' 'osativa_eg_gene')
TaxID=('3702' '4530')
for ((i=0; i < ${#Datasets[@]}; i++)); do
        echo ${TaxID[$i]}
        wget -O data/ensembl/${TaxID[$i]}.txt 'http://plants.ensembl.org/biomart/martservice?query=<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE Query><Query  virtualSchemaName = "plants_mart" formatter = "TSV" header = "0" uniqueRows = "0" count = "" datasetConfigVersion = "0.6" ><Dataset name = "'${Datasets[$i]}'" interface = "default" ><Attribute name = "entrezgene_id" /><Attribute name = "ensembl_peptide_id" /></Dataset></Query>'
done
