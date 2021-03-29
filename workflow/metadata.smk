import pandas as pd
from snakemake.utils import min_version

min_version("6.0.5")
configfile: "config.yaml"

METADATA_VERSION = config['METADATA_VERSION']
BIOC_VERSION = config['BIOC_VERSION']
SQLITE, = glob_wildcards('sqlite/{sqlite}.sqlite')

rule all:
	input:
		f'check/metadata_{METADATA_VERSION}'

#############################################
# METADATA
#############################################

rule metadata_csv:
	input:
		expand('sqlite/{sqlite}.sqlite', sqlite=SQLITE)
	output:
		'AHLRBaseDbs/inst/extdata/metadata_{METADATA_VERSION}.csv'
	container:
		"docker://koki/annotationhub:20210323"
	benchmark:
		'benchmarks/metadata_{METADATA_VERSION}.txt'
	log:
		'logs/metadata_{METADATA_VERSION}.log'
	shell:
		'src/metadata.sh {METADATA_VERSION} {BIOC_VERSION} {output} >& {log}'

rule metadata_check:
	input:
		'AHLRBaseDbs/inst/extdata/metadata_{METADATA_VERSION}.csv'
	output:
		'check/metadata_{METADATA_VERSION}'
	container:
		"docker://koki/annotationhub:20210323"
	benchmark:
		'benchmarks/metadata_check_{METADATA_VERSION}.txt'
	log:
		'logs/metadata_check_{METADATA_VERSION}.log'
	shell:
		'src/metadata_check.sh {input} {output} >& {log}'
