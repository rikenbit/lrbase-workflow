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
		'data/fantom5/fantom5.csv',
		'data/baderlab/baderlab.csv'

#############################################
# Preprocess
#############################################
rule preprocess_fantom5:
	input:
		'data/fantom5/PairsLigRec.txt',
		'data/fantom5/ncomms8866-s3.xlsx',
		'data/ensembl/9606_symbol.txt'
	output:
		'data/fantom5/fantom5.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_fantom5.txt'
	log:
		'logs/preprocess_fantom5.log'
	shell:
		'src/preprocess_fantom5.sh >& {log}'

rule preprocess_baderlab:
	input:
		'data/baderlab/receptor_ligand_interactions_mitab_v1.0_April2017.txt'
	output:
		'data/baderlab/baderlab.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_baderlab.txt'
	log:
		'logs/preprocess_baderlab.log'
	shell:
		'src/preprocess_baderlab.sh >& {log}'