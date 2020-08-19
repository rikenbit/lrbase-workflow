import pandas as pd
from snakemake.utils import min_version

min_version("5.8.1")
configfile: "config.yaml"

SAMPLESHEET = pd.read_csv('sample_sheet.csv', dtype='string')
TAXIDS = SAMPLESHEET['Taxon.ID'].unique()
VERSION_LRBASE = config['VERSION_LRBASE']

rule all:
	input:
		expand('check/rinstall_{taxid}_{v}_ok',
			taxid=TAXIDS, v=VERSION_LRBASE),
		# expand('reports/{taxid}_{v}/index.html',
		# 	taxid=TAXIDS, v=VERSION_LRBASE)

#############################################
# METADATA
#############################################
rule metadata:
	input:
		'sample_sheet.csv'
	output:
		touch(expand('data/metadata/{taxid}.csv',
			taxid=TAXIDS))
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/metadata.txt'
	log:
		'logs/metadata.log'
	shell:
		'src/metadata.sh >& {log}'

#############################################
# R packaging
#############################################

rule packaging_rpack:
	input:
		'data/metadata/{taxid}.csv',
		'data/csv/{taxid}.csv'
	output:
		'check/rpack_{taxid}_ok'
	container:
		"docker://koki/biocdev:latest"
	benchmark:
		'benchmarks/packaging_rpack_{taxid}.txt'
	log:
		'logs/packaging_rpack_{taxid}.log'
	shell:
		'src/packaging_rpack.sh {input} {wildcards.taxid} {VERSION_LRBASE} {output} >& {log}'

rule packaging_rbuild:
	input:
		'check/rpack_{taxid}_ok'
	output:
		'check/rbuild_{taxid}_ok'
	container:
		"docker://koki/biocdev:latest"
	benchmark:
		'benchmarks/packaging_rbuild_{taxid}.txt'
	log:
		'logs/packaging_rbuild_{taxid}.log'
	shell:
		'src/packaging_rbuild.sh {wildcards.taxid} {VERSION_LRBASE} {output} >& {log}'

rule packaging_rcheck:
	input:
		'check/rbuild_{taxid}_ok',
	output:
		'check/rcheck_{taxid}_{v}_ok'
	container:
		"docker://koki/biocdev:latest"
	benchmark:
		'benchmarks/packaging_rcheck_{taxid}_{v}.txt'
	log:
		'logs/packaging_rcheck_{taxid}_{v}.log'
	shell:
		'src/packaging_rcheck.sh {wildcards.taxid} {VERSION_LRBASE} {output} >& {log}'

rule packaging_rinstall:
	input:
		'check/rcheck_{taxid}_{v}_ok'
	output:
		'check/rinstall_{taxid}_{v}_ok'
	container:
		"docker://koki/biocdev:latest"
	benchmark:
		'benchmarks/packaging_rinstall_{taxid}_{v}.txt'
	log:
		'logs/packaging_rinstall_{taxid}_{v}.log'
	shell:
		'src/packaging_rinstall.sh {wildcards.taxid} {VERSION_LRBASE} {output} >& {log}'

#############################################
# Test scTensor report
#############################################
rule test_sctensor:
	input:
		'check/rinstall_{taxid}_{v}_ok'
	output:
		'reports/{taxid}_{v}/index.html'
	container:
		"docker://koki/biocdev:latest"
	benchmark:
		'benchmarks/test_sctensor_{taxid}_{v}.txt'
	log:
		'logs/test_sctensor_{taxid}_{v}.log'
	shell:
		'src/test_sctensor.sh {wildcards.taxid} {VERSION_LRBASE} >& {log}'
