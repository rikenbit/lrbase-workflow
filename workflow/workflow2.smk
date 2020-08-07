import pandas as pd

SAMPLESHEET = pd.read_csv('sample_sheet.csv', dtype='string')
NAMES = SAMPLESHEET['Scientific.name'].unique()
THREENAMES = SAMPLESHEET['Abbreviation'].unique()
COMMONNAMES = SAMPLESHEET['Common.name'].unique()
TAXID = SAMPLESHEET['Taxon.ID'].unique()

rule all:
	expand('data/metadata/')

#############################################
# METADATA
#############################################
rule metadata:
	input:
		'sample_sheet.csv'
	output:
		''

#############################################
# R packaging
#############################################
# src/RPack.sh
rule packaging_rpack:
# 	input:
# 		'sample_sheet.csv',
# 		expand('data/csv/{taxid_all}.csv',
# 			taxid_all=TAXID_ALL)
# 	output:
# 		'packages/LRBase.{taxid_all}.eg.db.tar.gz'
# 	conda:
# 		'envs/myenv.yaml'
# 	benchmark:
# 		'benchmarks/sample_sheet.txt'
# 	log:
# 		'logs/sample_sheet.log'
# 	shell:
# 		'src/sample_sheet.sh >& {log}'

# src/RBuild.sh
rule packaging_rbuild:

# src/RCheck.sh
rule packaging_rcheck:

# src/RBiocCheck.sh
rule packaging_bioccheck:

# src/RInstall.sh
rule packaging_install:

#############################################
# Test scTensor report
#############################################
rule test_sctensor:
