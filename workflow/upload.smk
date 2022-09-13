import pandas as pd
from snakemake.utils import min_version

min_version("6.0.5")
configfile: "config.yaml"

METADATA_VERSION = config['METADATA_VERSION']
URL = config['URL']

rule all:
	input:
                # check
                f'check/upload_{METADATA_VERSION}',
                f'check/azcopy_{METADATA_VERSION}'


#############################################
# Upload
#############################################
rule prepare_data:
	output:
		'check/upload_{METADATA_VERSION}'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/upload_prepare_data_{METADATA_VERSION}.txt'
	log:
		'logs/upload_prepare_data_{METADATA_VERSION}.log'
	shell:
		'src/upload_prepare_data_AHLRBaseDbs.sh {METADATA_VERSION} {output} >& {log}'

rule upload:
	input:
		'check/upload_{METADATA_VERSION}'
	output:
		'check/azcopy_{METADATA_VERSION}'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/upload_upload_{METADATA_VERSION}.txt'
	log:
		'logs/upload_upload_{METADATA_VERSION}.log'
	shell:
		'src/upload_AHLRBaseDbs.sh "{URL}" {output} >& {log}'
