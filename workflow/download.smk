import pandas as pd
from snakemake.utils import min_version

min_version("6.0.5")
configfile: "config.yaml"

ENSEMBL = pd.read_csv(config['ENSEMBL'], dtype='string')
NCBI = pd.read_csv(config['NCBI'], dtype='string')
RBBH = pd.read_csv(config['RBBH'], dtype='string')
PUTATIVE = pd.read_csv(config['PUTATIVE'], dtype='string')

# Ensembl (158)
TAXID_ENSEMBL = ENSEMBL['Taxon.ID'].unique()
# NCBI (20)
TAXID_NCBI = NCBI['Taxon.ID'].unique()
# RBBH (100)
TAXID_RBBH = RBBH['Taxon.ID'].unique()
THREENAME_RBBH = RBBH['Abbreviation'].unique()
# Known (247)
TAXID_KNOWN = set(TAXID_ENSEMBL) | set(TAXID_NCBI) | set(TAXID_RBBH)
# Putative (12)
VERSION_STRING = config['VERSION_STRING']
TAXID_PUTATIVE = pd.read_csv(config['PUTATIVE'], header=None, dtype='string')
TAXID_PUTATIVE = TAXID_PUTATIVE[0].unique()
# All (248)
TAXID_ALL = list(TAXID_KNOWN | set(TAXID_PUTATIVE))

rule all:
	input:
		'data/fantom5/PairsLigRec.txt',
		'data/fantom5/ncomms8866-s3.xlsx',
		'data/dlrp/dlrp.txt',
		'data/iuphar/interactions.csv',
		'data/hprd/HPRD_Release9_062910/BINARY_PROTEIN_PROTEIN_INTERACTIONS.txt',
		expand('data/string/{taxid_putative}.protein.links.detailed.{v}.txt', taxid_putative=TAXID_PUTATIVE, v=VERSION_STRING),
		'data/uniprotkb/uniprot_sprot.dat',
		'data/uniprotkb/uniprot_trembl.dat',
		'data/ensembl/9606_symbol.txt',
		expand('data/ensembl/{taxid_putative}.txt',
			taxid_putative=TAXID_PUTATIVE),
		'data/cellphonedb/interactions_cellphonedb.csv',
		'data/cellphonedb/heterodimers.csv',
		'data/baderlab/receptor_ligand_interactions_mitab_v1.0_April2017.txt',
		'data/singlecellsignalr/LRdb.rda',
		'data/biomart/9606.csv',
		expand('data/biomart/{taxid_ensembl}.csv',
			taxid_ensembl=TAXID_ENSEMBL),
		'data/homologene/homologene.data'

# Copy CSV files from mesh-workflow on elwood
# This rule is not included in DAG
# To perform this execute like
# > snakemake -j 1 -f copy_from_meshworkflow -s workflow/download.smk
#############################################
rule copy_from_meshworkflow:
	output:
		expand("data/rbbh/{tr}.txt", tr=THREENAME_RBBH)
	wildcard_constraints:
		tr='|'.join([re.escape(x) for x in THREENAME_RBBH])
	shell:
		'src/copy_from_meshworkflow.sh'

#############################################

#############################################
# Data download
#############################################
rule download_fantom5:
	output:
		'data/fantom5/PairsLigRec.txt',
		'data/fantom5/ncomms8866-s3.xlsx'
	container:
		"docker://koki/workflow:20210327"
	benchmark:
		'benchmarks/download_fantom5.txt'
	log:
		'logs/download_fantom5.log'
	shell:
		'src/download_fantom5.sh >& {log}'

rule download_dlrp:
	output:
		'data/dlrp/dlrp.txt'
	container:
		"docker://koki/workflow:20210327"
	benchmark:
		'benchmarks/download_dlrp.txt'
	log:
		'logs/download_dlrp.log'
	shell:
		'src/download_dlrp.sh >& {log}'

rule download_iuphar:
	output:
		'data/iuphar/interactions.csv'
	container:
		"docker://koki/workflow:20210327"
	benchmark:
		'benchmarks/download_iuphar.txt'
	log:
		'logs/download_iuphar.log'
	shell:
		'src/download_iuphar.sh >& {log}'

rule download_hprd:
	output:
		'data/hprd/HPRD_Release9_062910/BINARY_PROTEIN_PROTEIN_INTERACTIONS.txt'
	container:
		"docker://koki/workflow:20210327"
	benchmark:
		'benchmarks/download_hprd.txt'
	log:
		'logs/download_hprd.log'
	shell:
		'src/download_hprd.sh >& {log}'

rule download_string:
	output:
		'data/string/{taxid_putative}.protein.links.detailed.{v}.txt'
	container:
		"docker://koki/workflow:20210327"
	benchmark:
		'benchmarks/download_string_{v}_{taxid_putative}.txt'
	log:
		'logs/download_string_{v}_{taxid_putative}.log'
	shell:
		'src/download_string.sh {wildcards.v} {wildcards.taxid_putative} >& {log}'

rule download_uniprotkb:
	output:
		'data/uniprotkb/uniprot_sprot.dat',
		'data/uniprotkb/uniprot_trembl.dat'
	container:
		'docker://koki/axel:20210326'
	benchmark:
		'benchmarks/download_uniprotkb.txt'
	log:
		'logs/download_uniprotkb.log'
	shell:
		'src/download_uniprotkb.sh >& {log}'

rule download_ensembl_human_symbol:
	output:
		'data/ensembl/9606_symbol.txt'
	container:
		"docker://koki/workflow:20210327"
	benchmark:
		'benchmarks/download_ensembl_human_symbol.txt'
	log:
		'logs/download_ensembl_human_symbol.log'
	shell:
		'src/download_ensembl_human_symbol.sh >& {log}'

rule download_ensembl:
	output:
		expand('data/ensembl/{taxid_putative}.txt',
			taxid_putative=TAXID_PUTATIVE)
	container:
		"docker://koki/workflow:20210327"
	benchmark:
		'benchmarks/download_ensembl.txt'
	log:
		'logs/download_ensembl.log'
	shell:
		'src/download_ensembl.sh >& {log}'

rule download_cellphonedb:
	output:
		'data/cellphonedb/interactions_cellphonedb.csv',
		'data/cellphonedb/heterodimers.csv'
	container:
		"docker://koki/workflow:20210327"
	benchmark:
		'benchmarks/download_cellphonedb.txt'
	log:
		'logs/download_cellphonedb.log'
	shell:
		'src/download_cellphonedb.sh >& {log}'

rule download_baderlab:
	output:
		'data/baderlab/receptor_ligand_interactions_mitab_v1.0_April2017.txt'
	container:
		"docker://koki/workflow:20210327"
	benchmark:
		'benchmarks/download_baderlab.txt'
	log:
		'logs/download_baderlab.log'
	shell:
		'src/download_baderlab.sh >& {log}'

rule download_singlecellsignalr:
	output:
		'data/singlecellsignalr/LRdb.rda'
	container:
		"docker://koki/workflow:20210327"
	benchmark:
		'benchmarks/download_singlecellsignalr.txt'
	log:
		'logs/download_singlecellsignalr.log'
	shell:
		'src/download_singlecellsignalr.sh >& {log}'

rule download_biomart_human:
	output:
		'data/biomart/9606.csv'
	container:
		"docker://koki/workflow:20210327"
	benchmark:
		'benchmarks/download_biomart_9606.txt'
	log:
		'logs/download_biomart_9606.log'
	shell:
		'src/download_biomart_human.sh >& {log}'

rule download_biomart:
	input:
		'data/biomart/9606.csv'
	output:
		'data/biomart/{taxid_ensembl}.csv'
	container:
		"docker://koki/workflow:20210327"
	wildcard_constraints:
		taxid_ensembl='|'.join([re.escape(x) for x in TAXID_ENSEMBL])
	benchmark:
		'benchmarks/download_biomart_{taxid_ensembl}.txt'
	log:
		'logs/download_biomart_{taxid_ensembl}.log'
	shell:
		'src/download_biomart.sh {wildcards.taxid_ensembl} {output} >& {log}'

rule download_homologene:
	output:
		'data/homologene/homologene.data'
	container:
		"docker://koki/workflow:20210327"
	benchmark:
		'benchmarks/download_homologene.txt'
	log:
		'logs/download_homologene.log'
	shell:
		'src/download_homologene.sh >& {log}'