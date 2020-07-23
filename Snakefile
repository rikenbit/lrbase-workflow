import pandas as pd

TAXID_ENSEMBL = pd.read_csv('id/ensembl/ensembl_samples.csv', dtype='string')
TAXID_ENSEMBL = TAXID_ENSEMBL['Taxon ID'].unique()

DATASET_ENSEMBL = pd.read_csv('id/ensembl/ensembl_samples.csv', dtype='string')
DATASET_ENSEMBL = DATASET_ENSEMBL['Dataset name'].unique()

TAXID_NCBI = pd.read_csv('id/ncbi/ncbi_samples.csv', dtype='string')
TAXID_NCBI = TAXID_NCBI['Taxon ID'].unique()

TAXID_MESH = pd.read_csv('id/mesh/taxid.txt', dtype='string', header=None)[0]
TAXID_MESH = TAXID_MESH.unique()

THREENAME_MESH = pd.read_csv('id/mesh/threename.txt', dtype='string', header=None)[0]
THREENAME_MESH = THREENAME_MESH.unique()

TAXID = set(TAXID_ENSEMBL) | set(TAXID_NCBI) | set(TAXID_MESH)

rule all:
	input:
		'plot/coverage.png',
		'plot/percentage.png',
		'id/lrbase/sample_sheet.csv'

rule biomart_human:
	output:
		touch('data/biomart/9606.csv')
	conda:
		'envs/myenv.yaml'
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
	wildcard_constraints:
		taxid_ensembl='|'.join([re.escape(x) for x in TAXID_ENSEMBL])
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/biomart_{taxid_ensembl}.txt'
	log:
		'logs/biomart_{taxid_ensembl}.log'
	shell:
		'src/biomart.sh {wildcards.taxid_ensembl} {output} >& {log}'

rule homologene:
	output:
		touch('data/homologene/{taxid_ncbi}.csv')
	wildcard_constraints:
		taxid_ncbi='|'.join([re.escape(x) for x in TAXID_NCBI])
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/homologene_{taxid_ncbi}.txt'
	log:
		'logs/homologene_{taxid_ncbi}.log'
	shell:
		'src/homologene.sh {wildcards.taxid_ncbi} {output} >& {log}'

def mesh_file(wld):
	idx=TAXID_MESH.to_numpy().tolist().index(wld.taxid_mesh)
	return('data/rbbh/' + THREENAME_MESH[idx] + '.txt')

rule rbbh:
	input:
		mesh_file
	output:
		touch('data/rbbh/{taxid_mesh}.csv')
	wildcard_constraints:
		taxid_mesh='|'.join([re.escape(x) for x in TAXID_MESH])
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/rbbh_{taxid_mesh}.txt'
	log:
		'logs/rbbh_{taxid_mesh}.log'
	shell:
		'src/rbbh.sh {input} {output} >& {log}'

rule coverage_summary:
	input:
		expand('data/biomart/{taxid_ensembl}.csv',
			taxid_ensembl=TAXID_ENSEMBL),
		expand('data/homologene/{taxid_ncbi}.csv',
			taxid_ncbi=TAXID_NCBI),
		expand('data/rbbh/{taxid_mesh}.csv',
			taxid_mesh=TAXID_MESH)
	output:
		'data/coverage_summary.RData'
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/coverage_summary.txt'
	log:
		'logs/coverage_summary.log'
	shell:
		'src/coverage_summary.sh >& {log}'

rule percentage_summary:
	input:
		expand('data/biomart/{taxid_ensembl}.csv',
			taxid_ensembl=TAXID_ENSEMBL),
		expand('data/homologene/{taxid_ncbi}.csv',
			taxid_ncbi=TAXID_NCBI),
		expand('data/rbbh/{taxid_mesh}.csv',
			taxid_mesh=TAXID_MESH)
	output:
		'data/percentage_summary.RData'
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/percentage_summary.txt'
	log:
		'logs/percentage_summary.log'
	shell:
		'src/percentage_summary.sh >& {log}'

rule plot_coverage:
	input:
		'data/coverage_summary.RData'
	output:
		'plot/coverage.png'
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/plot_coverage.txt'
	log:
		'logs/plot_coverage.log'
	shell:
		'src/plot_coverage.sh >& {log}'

rule plot_percentage:
	input:
		'data/percentage_summary.RData'
	output:
		'plot/percentage.png'
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/plot_percentage.txt'
	log:
		'logs/plot_percentage.log'
	shell:
		'src/plot_percentage.sh >& {log}'

rule sample_sheet:
	input:
		'data/percentage_summary.RData'
	output:
		'id/lrbase/sample_sheet.csv'
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/sample_sheet.txt'
	log:
		'logs/sample_sheet.log'
	shell:
		'src/sample_sheet.sh >& {log}'
