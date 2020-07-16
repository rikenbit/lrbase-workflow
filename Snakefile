# Firstly, we manually downloaded following files
# 1. Species.csv: https://asia.ensembl.org/info/about/species.html (Download whole table)
# 2. homologene.data: https://ftp.ncbi.nih.gov/pub/HomoloGene/current/homologene.data

# Next, we manually created ensembl_samples.csv and _samples.csv file about the taxonomy IDs below

import pandas as pd

TAXID_ENSEMBL = pd.read_csv('ensembl_samples.csv', dtype='string')
TAXID_ENSEMBL = TAXID_ENSEMBL['Taxon ID'].unique()

DATASET_ENSEMBL = pd.read_csv('ensembl_samples.csv', dtype='string')
DATASET_ENSEMBL = DATASET_ENSEMBL['Dataset name'].unique()

TAXID_NCBI = pd.read_csv('ncbi_samples.csv', dtype='string')
TAXID_NCBI = TAXID_NCBI['Taxon ID'].unique()

TAXID = set(TAXID_ENSEMBL) | set(TAXID_NCBI)


rule all:
	input:
		'plot/coverage.png',
		'plot/percentage.png',
		'sample_sheet.csv'

rule biomart_human:
	output:
		touch('data/biomart/9606.csv')
	benchmark:
		'benchmarks/biomart_9606.txt'
	log:
		'logs/biomart_9606.log'
	shell:
		'src/biomart_human.sh >& {log}'

rule biomart:
	input:
		'data/biomart/9606.csv'
	output:
		touch('data/biomart/{taxid_ensembl}.csv')
	benchmark:
		'benchmarks/biomart_{taxid_ensembl}.txt'
	log:
		'logs/biomart_{taxid_ensembl}.log'
	shell:
		'src/biomart.sh {wildcards.taxid_ensembl} {output} >& {log}'

rule homologene:
	output:
		touch('data/homologene/{taxid_ncbi}.csv')
	benchmark:
		'benchmarks/homologene_{taxid_ncbi}.txt'
	log:
		'logs/homologene_{taxid_ncbi}.log'
	shell:
		'src/homologene.sh {wildcards.taxid_ncbi} {output} >& {log}'

rule coveage_summary:
	input:
		expand('data/biomart/{taxid_ensembl}.csv',
			taxid_ensembl=TAXID_ENSEMBL),
		expand('data/homologene/{taxid_ncbi}.csv',
			taxid_ncbi=TAXID_NCBI)
	output:
		'data/coveage_summary.RData'
	benchmark:
		'benchmark/coveage_summary.txt'
	log:
		'log/coveage_summary.log'
	shell:
		'src/coveage_summary.sh >& {log}'

rule percentage_summary:
	input:
		expand('data/biomart/{taxid_ensembl}.csv',
			taxid_ensembl=TAXID_ENSEMBL),
		expand('data/homologene/{taxid_ncbi}.csv',
			taxid_ncbi=TAXID_NCBI)
	output:
		'data/percentage_summary.RData'
	benchmark:
		'benchmark/percentage_summary.txt'
	log:
		'log/percentage_summary.log'
	shell:
		'src/percentage_summary.sh >& {log}'

rule coverage:
	input:
		'data/coveage_summary.RData'
	output:
		'plot/coverage.png'
	benchmark:
		'benchmarks/coverage.txt'
	log:
		'logs/coverage.log'
	shell:
		'src/coverage.sh >& {log}'

rule percentage:
	input:
		'data/percentage_summary.RData'
	output:
		'plot/percentage.png'
	benchmark:
		'benchmarks/percentage.txt'
	log:
		'logs/percentage.log'
	shell:
		'src/percentage.sh >& {log}'

rule sample_sheet:
	input:
		'data/percentage_summary.RData'
	output:
		'sample_sheet.csv'
	benchmark:
		'benchmarks/sample_sheet.txt'
	log:
		'logs/sample_sheet.log'
	shell:
		'src/sample_sheet.sh >& {log}'
