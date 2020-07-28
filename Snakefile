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

VERSION_STRING = 'v11.0'
TAXID_STRING = pd.read_csv('id/string/taxid.txt', dtype='string', header=None)[0]
TAXID_STRING = TAXID_STRING.unique()

THREENAME_ENSEMBL = pd.read_csv('id/ensembl/threename.txt', dtype='string', header=None)[0]
THREENAME_ENSEMBL = THREENAME_ENSEMBL.unique()

TAXID_UNIPROTKB = pd.read_csv('id/uniprotkb/taxid.txt', dtype='string', header=None)[0]
TAXID_UNIPROTKB = TAXID_UNIPROTKB.unique()

rule all:
	input:
		'data/fantom5.txt',
		'data/dlrp/pre_dlrp2.csv',
		'data/iuphar/iuphar.csv',
		'data/hprd/HPRD_Release9_062910/BINARY_PROTEIN_PROTEIN_INTERACTIONS.txt',
		'data/hgnc/protein-coding_gene.txt',
		expand('data/string/{taxid_string}.protein.links.detailed.{v}.txt.gz',
			taxid_string=TAXID_STRING, v=VERSION_STRING),
		expand('data/uniprotkb/swissprot_{taxid_uniprotkb}_secreted.csv',
			taxid_uniprotkb=TAXID_UNIPROTKB),
		expand('data/uniprotkb/swissprot_{taxid_uniprotkb}_membrane.csv',
			taxid_uniprotkb=TAXID_UNIPROTKB),
		expand('data/uniprotkb/trembl_{taxid_uniprotkb}_secreted.csv',
			taxid_uniprotkb=TAXID_UNIPROTKB),
		expand('data/uniprotkb/trembl_{taxid_uniprotkb}_membrane.csv',
			taxid_uniprotkb=TAXID_UNIPROTKB),
		'data/gene2accession/gene2accession.gz',
		expand('data/ensembl/{threename_ensembl}.txt',
			threename_ensembl=THREENAME_ENSEMBL),
		'data/cellphonedb/cellphonedb.csv',
		'data/baderlab/baderlab.csv'
		# 'plot/coverage.png',
		# 'plot/percentage.png',
		# 'id/lrbase/sample_sheet.csv'

#############################################
# Data download
#############################################
rule download_fantom5:
	output:
		touch('data/fantom5/PairsLigRec.txt'),
		touch('data/fantom5/ncomms8866-s3.xlsx')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_fantom5.txt'
	log:
		'logs/download_fantom5.log'
	shell:
		'src/download_fantom5.sh >& {log}'

rule preprocess_fantom5:
	input:
		'data/fantom5/PairsLigRec.txt',
		'data/fantom5/ncomms8866-s3.xlsx',
		'data/ensembl/Hsa_Symbol.txt'
	output:
		touch('data/fantom5.txt')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_fantom5.txt'
	log:
		'logs/preprocess_fantom5.log'
	shell:
		'src/preprocess_fantom5.sh >& {log}'

rule download_dlrp:
	output:
		touch('data/dlrp/dlrp.txt')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_dlrp.txt'
	log:
		'logs/download_dlrp.log'
	shell:
		'src/download_dlrp.sh >& {log}'

rule preprocess_dlrp:
	input:
		'data/dlrp/dlrp.txt'
	output:
		touch('data/dlrp/pre_dlrp.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_dlrp.txt'
	log:
		'logs/preprocess_dlrp.log'
	shell:
		'src/preprocess_dlrp.sh >& {log}'

rule preprocess_dlrp2:
	input:
		'data/dlrp/pre_dlrp.csv'
	output:
		touch('data/dlrp/pre_dlrp2.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_dlrp2.txt'
	log:
		'logs/preprocess_dlrp2.log'
	shell:
		'src/preprocess_dlrp2.sh >& {log}'

rule download_iuphar:
	output:
		touch('data/iuphar/interactions.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_iuphar.txt'
	log:
		'logs/download_iuphar.log'
	shell:
		'src/download_iuphar.sh >& {log}'

rule preprocess_iuphar:
	input:
		'data/iuphar/interactions.csv',
		'data/ensembl/Hsa_Symbol.txt'
	output:
		touch('data/iuphar/iuphar.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_iuphar.txt'
	log:
		'logs/preprocess_iuphar.log'
	shell:
		'src/preprocess_iuphar.sh >& {log}'

rule download_hprd:
	output:
		'data/hprd/HPRD_Release9_062910/BINARY_PROTEIN_PROTEIN_INTERACTIONS.txt'
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_hprd.txt'
	log:
		'logs/download_hprd.log'
	shell:
		'src/download_hprd.sh >& {log}'

rule download_hgnc:
	output:
		touch('data/hgnc/protein-coding_gene.txt')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_hgnc.txt'
	log:
		'logs/download_hgnc.log'
	shell:
		'src/download_hgnc.sh >& {log}'

rule download_string:
	output:
		touch('data/string/{taxid_string}.protein.links.detailed.{v}.txt.gz')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_string_{v}_{taxid_string}.txt'
	log:
		'logs/download_string_{v}_{taxid_string}.log'
	shell:
		'src/download_string.sh {wildcards.v} {wildcards.taxid_string} >& {log}'

rule download_uniprotkb:
	output:
		touch('data/uniprotkb/uniprot_sprot.dat'),
		touch('data/uniprotkb/uniprot_trembl.dat')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_uniprotkb.txt'
	log:
		'logs/download_uniprotkb.log'
	shell:
		'src/download_uniprotkb.sh >& {log}'

rule preprocess_swissprot:
	input:
		'data/uniprotkb/uniprot_sprot.dat'
	output:
		touch('data/uniprotkb/swissprot_{taxid_uniprotkb}.csv')
	wildcard_constraints:
		taxid_uniprotkb='|'.join([re.escape(x) for x in TAXID_UNIPROTKB])
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_swissprot_{taxid_uniprotkb}.txt'
	log:
		'logs/preprocess_swissprot_{taxid_uniprotkb}.log'
	shell:
		'src/preprocess_swissprot.sh {wildcards.taxid_uniprotkb} >& {log}'

rule preprocess_swissprot_secreted:
	input:
		'data/uniprotkb/swissprot_{taxid_uniprotkb}.csv'
	output:
		touch('data/uniprotkb/swissprot_{taxid_uniprotkb}_secreted.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_swissprot_{taxid_uniprotkb}_secreted.txt'
	log:
		'logs/preprocess_swissprot_{taxid_uniprotkb}_secreted.log'
	shell:
		'src/preprocess_swissprot_secreted.sh {wildcards.taxid_uniprotkb} >& {log}'

rule preprocess_swissprot_membrane:
	input:
		'data/uniprotkb/swissprot_{taxid_uniprotkb}.csv'
	output:
		touch('data/uniprotkb/swissprot_{taxid_uniprotkb}_membrane.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_swissprot_{taxid_uniprotkb}_membrane.txt'
	log:
		'logs/preprocess_swissprot_{taxid_uniprotkb}_membrane.log'
	shell:
		'src/preprocess_swissprot_membrane.sh {wildcards.taxid_uniprotkb} >& {log}'

rule preprocess_trembl:
	input:
		'data/uniprotkb/uniprot_trembl.dat'
	output:
		touch('data/uniprotkb/trembl_{taxid_uniprotkb}.csv')
	wildcard_constraints:
		taxid_uniprotkb='|'.join([re.escape(x) for x in TAXID_UNIPROTKB])
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_trembl_{taxid_uniprotkb}.txt'
	log:
		'logs/preprocess_trembl_{taxid_uniprotkb}.log'
	shell:
		'src/preprocess_trembl.sh {wildcards.taxid_uniprotkb} >& {log}'

rule preprocess_trembl_secreted:
	input:
		'data/uniprotkb/trembl_{taxid_uniprotkb}.csv'
	output:
		touch('data/uniprotkb/trembl_{taxid_uniprotkb}_secreted.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_trembl_{taxid_uniprotkb}_secreted.txt'
	log:
		'logs/preprocess_trembl_{taxid_uniprotkb}_secreted.log'
	shell:
		'src/preprocess_trembl_secreted.sh {wildcards.taxid_uniprotkb} >& {log}'

rule preprocess_trembl_membrane:
	input:
		'data/uniprotkb/trembl_{taxid_uniprotkb}.csv'
	output:
		touch('data/uniprotkb/trembl_{taxid_uniprotkb}_membrane.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_trembl_{taxid_uniprotkb}_membrane.txt'
	log:
		'logs/preprocess_trembl_{taxid_uniprotkb}_membrane.log'
	shell:
		'src/preprocess_trembl_membrane.sh {wildcards.taxid_uniprotkb} >& {log}'

rule download_gene2accession:
	output:
		touch('data/gene2accession/gene2accession.gz')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_gene2accession.txt'
	log:
		'logs/download_gene2accession.log'
	shell:
		'src/download_gene2accession.sh >& {log}'

rule download_ensembl:
	output:
		touch(expand('data/ensembl/{threename_ensembl}.txt',
			threename_ensembl=THREENAME_ENSEMBL))
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_ensembl.txt'
	log:
		'logs/download_ensembl.log'
	shell:
		'src/download_ensembl.sh >& {log}'

rule download_cellphonedb:
	output:
		touch('data/cellphonedb/interactions_cellphonedb.csv'),
		touch('data/cellphonedb/heterodimers.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_cellphonedb.txt'
	log:
		'logs/download_cellphonedb.log'
	shell:
		'src/download_cellphonedb.sh >& {log}'

rule preprocess_cellphonedb:
	input:
		'data/cellphonedb/interactions_cellphonedb.csv',
		'data/cellphonedb/heterodimers.csv'
	output:
		'data/cellphonedb/cellphonedb.csv'
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_cellphonedb.txt'
	log:
		'logs/preprocess_cellphonedb.log'
	shell:
		'src/preprocess_cellphonedb.sh >& {log}'

rule download_baderlab:
	output:
		touch('data/baderlab/receptor_ligand_interactions_mitab_v1.0_April2017.txt.zip')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_baderlab.txt'
	log:
		'logs/download_baderlab.log'
	shell:
		'src/download_baderlab.sh >& {log}'

rule preprocess_baderlab:
	input:
		'data/baderlab/receptor_ligand_interactions_mitab_v1.0_April2017.txt.zip'
	output:
		'data/baderlab/baderlab.csv'
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_baderlab.txt'
	log:
		'logs/preprocess_baderlab.log'
	shell:
		'src/preprocess_baderlab.sh >& {log}'

rule download_biomart_human:
	output:
		touch('data/biomart/9606.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_biomart_9606.txt'
	log:
		'logs/download_biomart_9606.log'
	shell:
		'src/download_biomart_human.sh >& {log}'

rule download_biomart:
	input:
		'data/biomart/9606.csv'
	output:
		touch('data/biomart/{taxid_ensembl}.csv')
	wildcard_constraints:
		taxid_ensembl='|'.join([re.escape(x) for x in TAXID_ENSEMBL])
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_biomart_{taxid_ensembl}.txt'
	log:
		'logs/download_biomart_{taxid_ensembl}.log'
	shell:
		'src/download_biomart.sh {wildcards.taxid_ensembl} {output} >& {log}'

rule download_homologene:
	output:
		touch('data/homologene/{taxid_ncbi}.csv')
	wildcard_constraints:
		taxid_ncbi='|'.join([re.escape(x) for x in TAXID_NCBI])
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_homologene_{taxid_ncbi}.txt'
	log:
		'logs/download_homologene_{taxid_ncbi}.log'
	shell:
		'src/download_homologene.sh {wildcards.taxid_ncbi} {output} >& {log}'

#############################################
# Summary
#############################################
def mesh_file(wld):
	idx=TAXID_MESH.to_numpy().tolist().index(wld.taxid_mesh)
	return('data/rbbh/' + THREENAME_MESH[idx] + '.txt')

rule summary_rbbh:
	input:
		mesh_file
	output:
		touch('data/rbbh/{taxid_mesh}.csv')
	wildcard_constraints:
		taxid_mesh='|'.join([re.escape(x) for x in TAXID_MESH])
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/summary_rbbh_{taxid_mesh}.txt'
	log:
		'logs/summary_rbbh_{taxid_mesh}.log'
	shell:
		'src/summary_rbbh.sh {input} {output} >& {log}'

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

#############################################
# Visualization
#############################################
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

#############################################
# Final Sample sheet
#############################################
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
