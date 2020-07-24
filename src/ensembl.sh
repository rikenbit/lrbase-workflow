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

# Only Human（Symbol - Gene ID）
wget -O data/ensembl/Hsa_Symbol.txt 'http://www.ensembl.org/biomart/martservice?query=<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE Query><Query  virtualSchemaName = "default" formatter = "TSV" header = "0" uniqueRows = "0" count = "" datasetConfigVersion = "0.6" ><Dataset name = "hsapiens_gene_ensembl" interface = "default" ><Attribute name = "entrezgene" /><Attribute name = "hgnc_symbol" /></Dataset></Query>'

# Animal
Datasets=('hsapiens_gene_ensembl' 'mmusculus_gene_ensembl' 'rnorvegicus_gene_ensembl' 'btaurus_gene_ensembl' 'celegans_gene_ensembl' 'dmelanogaster_gene_ensembl' 'drerio_gene_ensembl' 'ggallus_gene_ensembl' 'pabelii_gene_ensembl' 'xtropicalis_gene_ensembl' 'sscrofa_gene_ensembl')
Threename=('Hsa' 'Mmu' 'Rno' 'Bta' 'Cel' 'Dme' 'Dre' 'Gga' 'Pab' 'Xtr' 'Ssc')
for ((i=0; i < ${#Datasets[@]}; i++)); do
        echo ${Threename[$i]}
        wget -O data/ensembl/${Threename[$i]}.txt 'http://www.ensembl.org/biomart/martservice?query=<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE Query><Query  virtualSchemaName = "default" formatter = "TSV" header = "0" uniqueRows = "0" count = "" datasetConfigVersion = "0.6" ><Dataset name = "'${Datasets[$i]}'" interface = "default" ><Attribute name = "entrezgene" /><Attribute name = "ensembl_peptide_id" /></Dataset></Query>'
done

# Plant
Datasets=('athaliana_eg_gene' 'osativa_eg_gene')
Threename=('Ath' 'Osa')
for ((i=0; i < ${#Datasets[@]}; i++)); do
        echo ${Threename[$i]}
        wget -O data/ensembl/${Threename[$i]}.txt 'http://plants.ensembl.org/biomart/martservice?query=<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE Query><Query  virtualSchemaName = "plants_mart" formatter = "TSV" header = "0" uniqueRows = "0" count = "" datasetConfigVersion = "0.6" ><Dataset name = "'${Datasets[$i]}'" interface = "default" ><Attribute name = "entrezgene" /><Attribute name = "ensembl_peptide_id" /></Dataset></Query>'
done
