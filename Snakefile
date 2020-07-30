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

TAXID_KNOWN = set(TAXID_ENSEMBL) | set(TAXID_NCBI) | set(TAXID_MESH)

VERSION_STRING = 'v11.0'
TAXID_STRING = pd.read_csv('id/string/taxid.txt', dtype='string', header=None)[0]
TAXID_STRING = TAXID_STRING.unique()

TAXID_UNIPROTKB = pd.read_csv('id/uniprotkb/taxid.txt', dtype='string', header=None)[0]
TAXID_UNIPROTKB = TAXID_UNIPROTKB.unique()

TAXID_PUTATIVE = set(TAXID_UNIPROTKB) & set(TAXID_STRING)

TAXID_ALL = TAXID_KNOWN | TAXID_PUTATIVE

rule all:
	input:
		# After CSV...
		'data/fantom5/fantom5.csv',
		'data/cellphonedb/cellphonedb.csv',
		'data/baderlab/baderlab.csv',
		'data/singlecellsignalr/lrdb.csv',
		# Venn Diagram
		expand('plot/venndiagram_{db}_9606_{v}_{thr}.png',
			db=['swissprot_string', 'trembl_string'],
			v=VERSION_STRING,
			thr=['low', 'mid', 'high']),
		expand('plot/venndiagram_{db2}.png',
			db2=['swissprot_hprd', 'trembl_hprd']),
		# STRING Score plots
		'plot/swissprot_string_score.png',
		'plot/trembl_string_score.png',
		# Summary plots
		# 'data/coverage_summary.RData',
		# 'data/percentage_summary.RData'
		# 'plot/coverage.png',
		# 'plot/percentage.png',
		# Sample Sheet
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

rule download_string:
	output:
		touch('data/string/{taxid_putative}.protein.links.detailed.{v}.txt')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_string_{v}_{taxid_putative}.txt'
	log:
		'logs/download_string_{v}_{taxid_putative}.log'
	shell:
		'src/download_string.sh {wildcards.v} {wildcards.taxid_putative} >& {log}'

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

rule download_ensembl_human_symbol:
	output:
		touch('data/ensembl/9606_symbol.txt')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_ensembl_human_symbol.txt'
	log:
		'logs/download_ensembl_human_symbol.log'
	shell:
		'src/download_ensembl_human_symbol.sh >& {log}'

rule download_ensembl:
	output:
		touch(expand('data/ensembl/{taxid_putative}.txt',
			taxid_putative=TAXID_PUTATIVE))
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

rule download_singlecellsignalr:
	output:
		touch('data/singlecellsignalr/LRdb.rda')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/download_singlecellsignalr.txt'
	log:
		'logs/download_singlecellsignalr.log'
	shell:
		'src/download_singlecellsignalr.sh >& {log}'

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
# Preprocess
#############################################
rule preprocess_fantom5:
	input:
		'data/fantom5/PairsLigRec.txt',
		'data/fantom5/ncomms8866-s3.xlsx',
		'data/ensembl/9606_symbol.txt'
	output:
		touch('data/fantom5/fantom5.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_fantom5.txt'
	log:
		'logs/preprocess_fantom5.log'
	shell:
		'src/preprocess_fantom5.sh >& {log}'

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
		'data/dlrp/pre_dlrp.csv',
		'data/ensembl/9606_symbol.txt'
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

rule preprocess_iuphar:
	input:
		'data/iuphar/interactions.csv',
		'data/ensembl/9606_symbol.txt'
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

rule preprocess_swissprot:
	input:
		'data/uniprotkb/uniprot_sprot.dat'
	output:
		touch('data/uniprotkb/swissprot_{taxid_putative}.csv')
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE])
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_swissprot_{taxid_putative}.txt'
	log:
		'logs/preprocess_swissprot_{taxid_putative}.log'
	shell:
		'src/preprocess_swissprot.sh {wildcards.taxid_putative} >& {log}'

rule preprocess_swissprot_secreted:
	input:
		'data/uniprotkb/swissprot_{taxid_putative}.csv'
	output:
		touch('data/uniprotkb/swissprot_{taxid_putative}_secreted.csv')
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE])
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_swissprot_{taxid_putative}_secreted.txt'
	log:
		'logs/preprocess_swissprot_{taxid_putative}_secreted.log'
	shell:
		'src/preprocess_swissprot_secreted.sh {wildcards.taxid_putative} >& {log}'

rule preprocess_swissprot_membrane:
	input:
		'data/uniprotkb/swissprot_{taxid_putative}.csv'
	output:
		touch('data/uniprotkb/swissprot_{taxid_putative}_membrane.csv')
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE])
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_swissprot_{taxid_putative}_membrane.txt'
	log:
		'logs/preprocess_swissprot_{taxid_putative}_membrane.log'
	shell:
		'src/preprocess_swissprot_membrane.sh {wildcards.taxid_putative} >& {log}'

rule preprocess_trembl:
	input:
		'data/uniprotkb/uniprot_trembl.dat'
	output:
		touch('data/uniprotkb/trembl_{taxid_putative}.csv')
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE])
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_trembl_{taxid_putative}.txt'
	log:
		'logs/preprocess_trembl_{taxid_putative}.log'
	shell:
		'src/preprocess_trembl.sh {wildcards.taxid_putative} >& {log}'

rule preprocess_trembl_secreted:
	input:
		'data/uniprotkb/trembl_{taxid_putative}.csv'
	output:
		touch('data/uniprotkb/trembl_{taxid_putative}_secreted.csv')
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE])
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_trembl_{taxid_putative}_secreted.txt'
	log:
		'logs/preprocess_trembl_{taxid_putative}_secreted.log'
	shell:
		'src/preprocess_trembl_secreted.sh {wildcards.taxid_putative} >& {log}'

rule preprocess_trembl_membrane:
	input:
		'data/uniprotkb/trembl_{taxid_putative}.csv'
	output:
		touch('data/uniprotkb/trembl_{taxid_putative}_membrane.csv')
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE])
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_trembl_{taxid_putative}_membrane.txt'
	log:
		'logs/preprocess_trembl_{taxid_putative}_membrane.log'
	shell:
		'src/preprocess_trembl_membrane.sh {wildcards.taxid_putative} >& {log}'

rule preprocess_swissprot_hprd:
	input:
		'data/ensembl/9606_symbol.txt',
		'data/uniprotkb/swissprot_9606_secreted.csv',
		'data/uniprotkb/swissprot_9606_membrane.csv',
		'data/hprd/HPRD_Release9_062910/BINARY_PROTEIN_PROTEIN_INTERACTIONS.txt'
	output:
		touch('data/swissprot_hprd/9606.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_swissprot_hprd.txt'
	log:
		'logs/preprocess_swissprot_hprd.log'
	shell:
		'src/preprocess_swissprot_hprd.sh >& {log}'

rule preprocess_trembl_hprd:
	input:
		'data/ensembl/9606_symbol.txt',
		'data/uniprotkb/trembl_9606_secreted.csv',
		'data/uniprotkb/trembl_9606_membrane.csv',
		'data/hprd/HPRD_Release9_062910/BINARY_PROTEIN_PROTEIN_INTERACTIONS.txt'
	output:
		touch('data/trembl_hprd/9606.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_trembl_hprd.txt'
	log:
		'logs/preprocess_trembl_hprd.log'
	shell:
		'src/preprocess_trembl_hprd.sh >& {log}'

rule preprocess_swissprot_string:
	input:
		'data/ensembl/{taxid_putative}.txt',
		'data/uniprotkb/swissprot_{taxid_putative}_secreted.csv',
		'data/uniprotkb/swissprot_{taxid_putative}_membrane.csv',
		'data/string/{taxid_putative}.protein.links.detailed.{v}.txt'
	output:
		touch('data/swissprot_string/{taxid_putative}_{v}.csv')
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_swissprot_string_{taxid_putative}_{v}.txt'
	log:
		'logs/preprocess_swissprot_string_{taxid_putative}_{v}.log'
	shell:
		'src/preprocess_swissprot_string.sh {wildcards.taxid_putative} {wildcards.v} >& {log}'

rule preprocess_trembl_string:
	input:
		'data/ensembl/{taxid_putative}.txt',
		'data/uniprotkb/trembl_{taxid_putative}_secreted.csv',
		'data/uniprotkb/trembl_{taxid_putative}_membrane.csv',
		'data/string/{taxid_putative}.protein.links.detailed.{v}.txt'
	output:
		touch('data/trembl_string/{taxid_putative}_{v}.csv')
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_trembl_string_{taxid_putative}_{v}.txt'
	log:
		'logs/preprocess_trembl_string_{taxid_putative}_{v}.log'
	shell:
		'src/preprocess_trembl_string.sh {wildcards.taxid_putative} {wildcards.v} >& {log}'

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

rule preprocess_singlecellsignalr:
	input:
		'data/singlecellsignalr/LRdb.rda',
		'data/ensembl/9606_symbol.txt'
	output:
		'data/singlecellsignalr/lrdb.csv'
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/preprocess_singlecellsignalr.txt'
	log:
		'logs/preprocess_singlecellsignalr.log'
	shell:
		'src/preprocess_singlecellsignalr.sh >& {log}'

#############################################
# Summary
#############################################

rule summary_confidence_swissprot_string_low:
	input:
		'data/swissprot_string/{taxid_putative}_{v}.csv'
	output:
		touch('data/swissprot_string/{taxid_putative}_{v}_low.csv')
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/summary_confidence_swissprot_string_{taxid_putative}_{v}.txt'
	log:
		'logs/summary_confidence_swissprot_string_{taxid_putative}_{v}.log'
	shell:
		'src/summary_confidence_swissprot_string.sh {wildcards.taxid_putative} {wildcards.v} 150 >& {log}'

rule summary_confidence_swissprot_string_mid:
	input:
		'data/swissprot_string/{taxid_putative}_{v}.csv'
	output:
		touch('data/swissprot_string/{taxid_putative}_{v}_mid.csv')
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/summary_confidence_swissprot_string_{taxid_putative}_{v}.txt'
	log:
		'logs/summary_confidence_swissprot_string_{taxid_putative}_{v}.log'
	shell:
		'src/summary_confidence_swissprot_string.sh {wildcards.taxid_putative} {wildcards.v} 400 >& {log}'

rule summary_confidence_swissprot_string_high:
	input:
		'data/swissprot_string/{taxid_putative}_{v}.csv'
	output:
		touch('data/swissprot_string/{taxid_putative}_{v}_high.csv')
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/summary_confidence_swissprot_string_{taxid_putative}_{v}.txt'
	log:
		'logs/summary_confidence_swissprot_string_{taxid_putative}_{v}.log'
	shell:
		'src/summary_confidence_swissprot_string.sh {wildcards.taxid_putative} {wildcards.v} 700 >& {log}'

rule summary_confidence_trembl_string_low:
	input:
		'data/trembl_string/{taxid_putative}_{v}.csv'
	output:
		touch('data/trembl_string/{taxid_putative}_{v}_low.csv')
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/summary_confidence_trembl_string_{taxid_putative}_{v}.txt'
	log:
		'logs/summary_confidence_trembl_string_{taxid_putative}_{v}.log'
	shell:
		'src/summary_confidence_trembl_string.sh {wildcards.taxid_putative} {wildcards.v} 150 >& {log}'

rule summary_confidence_trembl_string_mid:
	input:
		'data/trembl_string/{taxid_putative}_{v}.csv'
	output:
		touch('data/trembl_string/{taxid_putative}_{v}_mid.csv')
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/summary_confidence_trembl_string_{taxid_putative}_{v}.txt'
	log:
		'logs/summary_confidence_trembl_string_{taxid_putative}_{v}.log'
	shell:
		'src/summary_confidence_trembl_string.sh {wildcards.taxid_putative} {wildcards.v} 400 >& {log}'

rule summary_confidence_trembl_string_high:
	input:
		'data/trembl_string/{taxid_putative}_{v}.csv'
	output:
		touch('data/trembl_string/{taxid_putative}_{v}_high.csv')
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE]),
		v=VERSION_STRING
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/summary_confidence_trembl_string_{taxid_putative}_{v}.txt'
	log:
		'logs/summary_confidence_trembl_string_{taxid_putative}_{v}.log'
	shell:
		'src/summary_confidence_trembl_string.sh {wildcards.taxid_putative} {wildcards.v} 700 >& {log}'



rule summary_csv:


# From meshr-pipeline
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





# CSVレベルでマージされた後
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
rule plot_string_score:
	input:
		expand('data/{db}/{taxid_putative}_{v}_{thr}.csv',
			db=["trembl_string", "swissprot_string"],
			taxid_putative=TAXID_PUTATIVE,
			v=VERSION_STRING,
			thr=['low', 'mid', 'high'])
	output:
		'plot/swissprot_string_score.png',
		'plot/trembl_string_score.png'
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/plot_string_score.txt'
	log:
		'logs/plot_string_score.log'
	shell:
		'src/plot_string_score.sh {input} >& {log}'

rule plot_venndiagram_uniprotkb_string:
	input:
		'data/{db}/9606_{v}_{thr}.csv',
		'data/fantom5/fantom5.csv',
		'data/iuphar/iuphar.csv',
		'data/dlrp/pre_dlrp2.csv'
	output:
		'plot/venndiagram_{db}_9606_{v}_{thr}.png'
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/plot_venndiagram_uniprotkb_string_{db}_{v}_{thr}.txt'
	log:
		'logs/plot_venndiagram_uniprotkb_string_{db}_{v}_{thr}.log'
	shell:
		'src/plot_venndiagram_uniprotkb_string.sh {input} {output} >& {log}'

rule plot_venndiagram_uniprotkb_hprd:
	input:
		'data/{db2}/9606.csv',
		'data/fantom5/fantom5.csv',
		'data/iuphar/iuphar.csv',
		'data/dlrp/pre_dlrp2.csv'
	output:
		'plot/venndiagram_{db2}.png'
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/plot_venndiagram_uniprotkb_hprd_{db2}.txt'
	log:
		'logs/plot_venndiagram_uniprotkb_hprd_{db2}.log'
	shell:
		'src/plot_venndiagram_uniprotkb_hprd.sh {input} {output} >& {log}'

# # CSV後
# rule plot_venndiagram_lrbase:
# 	input:
# 		'data/csv/9606.csv',
# 		'data/fantom5/fantom5.csv',
# 		'data/cellphonedb/cellphonedb.csv',
# 		'data/baderlab/baderlab.csv',
# 		'data/singlecellsignalr/lrdb.csv',
# 	output:
# 		'plot/venndiagram_lrbase.png'
# 	conda:
# 		'envs/myenv.yaml'
# 	benchmark:
# 		'benchmarks/plot_venndiagram_lrbase.txt'
# 	log:
# 		'logs/plot_venndiagram_lrbase.log'
# 	shell:
# 		'src/plot_venndiagram_lrbase.sh {input} >& {log}'

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


#############################################
# Final Packaging
#############################################
# sample_sheetをinput:とする

# src/RPack.sh
rule packaging_rpack:

# src/RBuild.sh
rule packaging_rbuild:

# src/RCheck.sh
rule packaging_rcheck:

# src/RBiocCheck.sh
rule packaging_bioccheck:

# src/RInstall.sh
rule packaging_install:
