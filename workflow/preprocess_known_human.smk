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
		'data/dlrp/pre_dlrp2.csv',
		'data/iuphar/iuphar.csv',
		'data/hpmr/hpmr.csv',
		'data/cellphonedb/cellphonedb.csv',
		'data/singlecellsignalr/lrdb.csv'

#############################################
# Preprocess
#############################################
rule preprocess_dlrp:
	input:
		'data/dlrp/dlrp.txt'
	output:
		'data/dlrp/pre_dlrp.csv'
	container:
		'docker://julia:1.6.0-rc1-buster'
	benchmark:
		'benchmarks/preprocess_dlrp.txt'
	log:
		'logs/preprocess_dlrp.log'
	shell:
		'src/preprocess_dlrp.sh >& {log}'

rule preprocess_dlrp2:
	input:
		'data/dlrp/pre_dlrp.csv',
		'data/ensembl/9606_symbol.txt'
	output:
		'data/dlrp/pre_dlrp2.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_dlrp2.txt'
	log:
		'logs/preprocess_dlrp2.log'
	shell:
		'src/preprocess_dlrp2.sh >& {log}'

rule preprocess_iuphar:
	input:
		'data/iuphar/interactions.csv',
		'data/ensembl/9606_symbol.txt'
	output:
		'data/iuphar/iuphar.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_iuphar.txt'
	log:
		'logs/preprocess_iuphar.log'
	shell:
		'src/preprocess_iuphar.sh >& {log}'

rule preprocess_hpmr:
	input:
		'data/fantom5/PairsLigRec.txt',
		'data/ensembl/9606_symbol.txt',
		'data/dlrp/pre_dlrp2.csv',
		'data/iuphar/iuphar.csv'
	output:
		'data/hpmr/hpmr.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_hpmr.txt'
	log:
		'logs/preprocess_hpmr.log'
	shell:
		'src/preprocess_hpmr.sh >& {log}'

rule preprocess_cellphonedb:
	input:
		'data/cellphonedb/interactions_cellphonedb.csv',
		'data/cellphonedb/heterodimers.csv'
	output:
		'data/cellphonedb/cellphonedb.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_cellphonedb.txt'
	log:
		'logs/preprocess_cellphonedb.log'
	shell:
		'src/preprocess_cellphonedb.sh >& {log}'

rule preprocess_singlecellsignalr:
	input:
		'data/singlecellsignalr/LRdb.rda',
		'data/ensembl/9606_symbol.txt'
	output:
		'data/singlecellsignalr/lrdb.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_singlecellsignalr.txt'
	log:
		'logs/preprocess_singlecellsignalr.log'
	shell:
		'src/preprocess_singlecellsignalr.sh >& {log}'