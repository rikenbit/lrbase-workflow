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
		expand('data/{db}/{taxid_putative}_{v}_{thr}.csv',
			taxid_putative=TAXID_PUTATIVE,
			db=['swissprot_string', 'trembl_string'],
			v=VERSION_STRING,
			thr=['low', 'mid', 'high']),

rule preprocess_swissprot_string:
	input:
		'data/ensembl/{taxid_putative}.txt',
		'data/uniprotkb/swissprot_{taxid_putative}_secreted.csv',
		'data/uniprotkb/swissprot_{taxid_putative}_membrane.csv',
		'data/string/{taxid_putative}.protein.links.detailed.{v}.txt'
	output:
		'data/swissprot_string/{taxid_putative}_{v}.csv'
	container:
		'docker://koki/workflow:20210327'
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	benchmark:
		'benchmarks/preprocess_swissprot_string_{taxid_putative}_{v}.txt'
	log:
		'logs/preprocess_swissprot_string_{taxid_putative}_{v}.log'
	shell:
		'src/preprocess_swissprot_string.sh {wildcards.taxid_putative} {wildcards.v} >& {log}'

rule preprocess_confidence_swissprot_string_low:
	input:
		'data/swissprot_string/{taxid_putative}_{v}.csv'
	output:
		'data/swissprot_string/{taxid_putative}_{v}_low.csv'
	container:
		'docker://koki/workflow:20210327'
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	benchmark:
		'benchmarks/preprocess_confidence_swissprot_string_{taxid_putative}_{v}.txt'
	log:
		'logs/preprocess_confidence_swissprot_string_{taxid_putative}_{v}.log'
	shell:
		'src/preprocess_confidence_swissprot_string.sh {wildcards.taxid_putative} {wildcards.v} 150 >& {log}'

rule preprocess_confidence_swissprot_string_mid:
	input:
		'data/swissprot_string/{taxid_putative}_{v}.csv'
	output:
		'data/swissprot_string/{taxid_putative}_{v}_mid.csv'
	container:
		'docker://koki/workflow:20210327'
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	benchmark:
		'benchmarks/preprocess_confidence_swissprot_string_{taxid_putative}_{v}.txt'
	log:
		'logs/preprocess_confidence_swissprot_string_{taxid_putative}_{v}.log'
	shell:
		'src/preprocess_confidence_swissprot_string.sh {wildcards.taxid_putative} {wildcards.v} 400 >& {log}'

rule preprocess_confidence_swissprot_string_high:
	input:
		'data/swissprot_string/{taxid_putative}_{v}.csv'
	output:
		'data/swissprot_string/{taxid_putative}_{v}_high.csv'
	container:
		'docker://koki/workflow:20210327'
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	benchmark:
		'benchmarks/preprocess_confidence_swissprot_string_{taxid_putative}_{v}.txt'
	log:
		'logs/preprocess_confidence_swissprot_string_{taxid_putative}_{v}.log'
	shell:
		'src/preprocess_confidence_swissprot_string.sh {wildcards.taxid_putative} {wildcards.v} 700 >& {log}'

rule preprocess_trembl_string:
	input:
		'data/ensembl/{taxid_putative}.txt',
		'data/uniprotkb/trembl_{taxid_putative}_secreted.csv',
		'data/uniprotkb/trembl_{taxid_putative}_membrane.csv',
		'data/string/{taxid_putative}.protein.links.detailed.{v}.txt'
	output:
		'data/trembl_string/{taxid_putative}_{v}.csv'
	container:
		'docker://koki/workflow:20210327'
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	benchmark:
		'benchmarks/preprocess_trembl_string_{taxid_putative}_{v}.txt'
	log:
		'logs/preprocess_trembl_string_{taxid_putative}_{v}.log'
	shell:
		'src/preprocess_trembl_string.sh {wildcards.taxid_putative} {wildcards.v} >& {log}'

rule preprocess_confidence_trembl_string_low:
	input:
		'data/trembl_string/{taxid_putative}_{v}.csv'
	output:
		'data/trembl_string/{taxid_putative}_{v}_low.csv'
	container:
		'docker://koki/workflow:20210327'
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	benchmark:
		'benchmarks/preprocess_confidence_trembl_string_{taxid_putative}_{v}.txt'
	log:
		'logs/preprocess_confidence_trembl_string_{taxid_putative}_{v}.log'
	shell:
		'src/preprocess_confidence_trembl_string.sh {wildcards.taxid_putative} {wildcards.v} 150 >& {log}'

rule preprocess_confidence_trembl_string_mid:
	input:
		'data/trembl_string/{taxid_putative}_{v}.csv'
	output:
		'data/trembl_string/{taxid_putative}_{v}_mid.csv'
	container:
		'docker://koki/workflow:20210327'
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	benchmark:
		'benchmarks/preprocess_confidence_trembl_string_{taxid_putative}_{v}.txt'
	log:
		'logs/preprocess_confidence_trembl_string_{taxid_putative}_{v}.log'
	shell:
		'src/preprocess_confidence_trembl_string.sh {wildcards.taxid_putative} {wildcards.v} 400 >& {log}'

rule preprocess_confidence_trembl_string_high:
	input:
		'data/trembl_string/{taxid_putative}_{v}.csv'
	output:
		'data/trembl_string/{taxid_putative}_{v}_high.csv'
	container:
		'docker://koki/workflow:20210327'
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	benchmark:
		'benchmarks/preprocess_confidence_trembl_string_{taxid_putative}_{v}.txt'
	log:
		'logs/preprocess_confidence_trembl_string_{taxid_putative}_{v}.log'
	shell:
		'src/preprocess_confidence_trembl_string.sh {wildcards.taxid_putative} {wildcards.v} 700 >& {log}'