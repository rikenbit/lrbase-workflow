import pandas as pd
from snakemake.utils import min_version

min_version("6.0.5")
configfile: "config.yaml"

SAMPLESHEET = pd.read_csv('sample_sheet/sample_sheet.csv', dtype='string')
TAXIDS = SAMPLESHEET['Taxon.ID'].unique()
COMMONNAMES = SAMPLESHEET['Common.name'].unique()
SCIENTIFICNAMES = SAMPLESHEET['Scientific.name'].unique()
THREENAMES = SAMPLESHEET['Abbreviation'].unique()

VERSION_STRING = config['VERSION_STRING']

rule all:
	input:
		expand('sqlite/LRBase.{tname}.eg.db.sqlite', tname=THREENAMES)

#############################################
# SQLite
#############################################
rule metadata_for_sqlite:
	input:
		'sample_sheet/sample_sheet.csv'
	output:
		expand('data/metadata_for_sqlite/{tname}.csv',
			tname=THREENAMES)
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/metadata_for_sqlite.txt'
	log:
		'logs/metadata_for_sqlite.log'
	shell:
		'src/metadata_for_sqlite.sh >& {log}'

def csvfile(wld):
	idx=THREENAMES.to_numpy().tolist().index(wld[0])
	return('data/csv/' + TAXIDS[idx] + ".csv")

rule sqlite:
	input:
		csvfile,
		'data/metadata_for_sqlite/{tname}.csv'
	output:
		'sqlite/LRBase.{tname}.eg.db.sqlite'
	wildcard_constraints:
		tname='|'.join([re.escape(x) for x in THREENAMES])
	container:
		"docker://nouchka/sqlite3:latest"
	benchmark:
		'benchmarks/sqlite_{tname}.txt'
	log:
		'logs/sqlite_{tname}.log'
	shell:
		'src/sqlite.sh {input} {output} >& {log}'
