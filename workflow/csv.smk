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
TAXID_PUTATIVE = PUTATIVE['Taxon.ID'].unique()
# All (248)
TAXID_ALL = list(TAXID_KNOWN | set(TAXID_PUTATIVE))

rule all:
	input:
		'sample_sheet/sample_sheet.csv'

#############################################
# CSV
#############################################
rule csv_human:
	input:
		expand('data/{db}/9606_{v}_{thr}.csv',
			db=['swissprot_string', 'trembl_string'],
			v=VERSION_STRING,
			thr=['high']),
		expand('data/{db2}/9606.csv',
			db2=['swissprot_hprd', 'trembl_hprd']),
		'data/iuphar/iuphar.csv',
		'data/dlrp/pre_dlrp2.csv',
		'data/hpmr/hpmr.csv',
		'data/fantom5/fantom5.csv',
		'data/cellphonedb/cellphonedb.csv',
		'data/baderlab/baderlab.csv',
		'data/singlecellsignalr/lrdb.csv'
	output:
		'data/csv/pre_9606.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/csv_human.txt'
	log:
		'logs/csv_human.log'
	shell:
		'src/csv_human.sh {input} {output} >& {log}'

rule csv:
	input:
		'data/csv/pre_9606.csv',
		# Known
		expand('data/ensembl_dlrp/{taxid_ensembl}.csv',
			taxid_ensembl=TAXID_ENSEMBL),
		expand('data/ensembl_iuphar/{taxid_ensembl}.csv',
			taxid_ensembl=TAXID_ENSEMBL),
		expand('data/ensembl_hpmr/{taxid_ensembl}.csv',
			taxid_ensembl=TAXID_ENSEMBL),
		expand('data/ensembl_cellphonedb/{taxid_ensembl}.csv',
			taxid_ensembl=TAXID_ENSEMBL),
		expand('data/ensembl_singlecellsignalr/{taxid_ensembl}.csv',
			taxid_ensembl=TAXID_ENSEMBL),

		expand('data/ncbi_dlrp/{taxid_ncbi}.csv',
			taxid_ncbi=TAXID_NCBI),
		expand('data/ncbi_iuphar/{taxid_ncbi}.csv',
			taxid_ncbi=TAXID_NCBI),
		expand('data/ncbi_hpmr/{taxid_ncbi}.csv',
			taxid_ncbi=TAXID_NCBI),
		expand('data/ncbi_cellphonedb/{taxid_ncbi}.csv',
			taxid_ncbi=TAXID_NCBI),
		expand('data/ncbi_singlecellsignalr/{taxid_ncbi}.csv',
			taxid_ncbi=TAXID_NCBI),

		expand('data/rbbh_dlrp/{taxid_rbbh}.csv',
			taxid_rbbh=TAXID_RBBH),
		expand('data/rbbh_iuphar/{taxid_rbbh}.csv',
			taxid_rbbh=TAXID_RBBH),
		expand('data/rbbh_hpmr/{taxid_rbbh}.csv',
			taxid_rbbh=TAXID_RBBH),
		expand('data/rbbh_cellphonedb/{taxid_rbbh}.csv',
			taxid_rbbh=TAXID_RBBH),
		expand('data/rbbh_singlecellsignalr/{taxid_rbbh}.csv',
			taxid_rbbh=TAXID_RBBH),

		# Putative
		expand('data/{db}/{taxid_putative}_{v}_{thr}.csv',
			taxid_putative=TAXID_PUTATIVE,
			db=['swissprot_string', 'trembl_string'],
			v=VERSION_STRING,
			thr=['high']),

		expand('data/ensembl_swissprot_hprd/{taxid_ensembl}.csv',
			taxid_ensembl=TAXID_ENSEMBL),
		expand('data/ensembl_trembl_hprd/{taxid_ensembl}.csv',
			taxid_ensembl=TAXID_ENSEMBL),
		expand('data/ensembl_fantom5/{taxid_ensembl}.csv',
			taxid_ensembl=TAXID_ENSEMBL),
		expand('data/ensembl_baderlab/{taxid_ensembl}.csv',
			taxid_ensembl=TAXID_ENSEMBL),

		expand('data/ncbi_swissprot_hprd/{taxid_ncbi}.csv',
			taxid_ncbi=TAXID_NCBI),
		expand('data/ncbi_trembl_hprd/{taxid_ncbi}.csv',
			taxid_ncbi=TAXID_NCBI),
		expand('data/ncbi_fantom5/{taxid_ncbi}.csv',
			taxid_ncbi=TAXID_NCBI),
		expand('data/ncbi_baderlab/{taxid_ncbi}.csv',
			taxid_ncbi=TAXID_NCBI),

		expand('data/rbbh_swissprot_hprd/{taxid_rbbh}.csv',
			taxid_rbbh=TAXID_RBBH),
		expand('data/rbbh_trembl_hprd/{taxid_rbbh}.csv',
			taxid_rbbh=TAXID_RBBH),
		expand('data/rbbh_fantom5/{taxid_rbbh}.csv',
			taxid_rbbh=TAXID_RBBH),
		expand('data/rbbh_baderlab/{taxid_rbbh}.csv',
			taxid_rbbh=TAXID_RBBH)
	output:
		'data/csv/{taxid_all}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/csv_{taxid_all}.txt'
	log:
		'logs/csv_{taxid_all}.log'
	shell:
		'src/csv.sh {wildcards.taxid_all} {VERSION_STRING} {output} >& {log}'

rule summary:
	input:
		expand('data/csv/{taxid_all}.csv',
			taxid_all=TAXID_ALL)
	output:
		'data/summary.RData'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/summary.txt'
	log:
		'logs/summary.log'
	shell:
		'src/summary.sh {VERSION_STRING} >& {log}'

rule sample_sheet:
	input:
		'data/summary.RData'
	output:
		'sample_sheet/sample_sheet.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/sample_sheet.txt'
	log:
		'logs/sample_sheet.log'
	shell:
		'src/sample_sheet.sh >& {log}'