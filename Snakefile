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
TAXID_STRING = ['9606', '10090', '3702', '10116', '9913', '224308', '44689', '6239', '7227', '7955', '9031', '9601', '83332', '243232', '71421', '8364', '199310', '9823', '224325']

THREENAME_ENSEMBL = ['Hsa_Symbol.txt', 'Hsa', 'Mmu', 'Rno', 'Bta', 'Cel', 'Dme', 'Dre', 'Gga', 'Pab', 'Xtr', 'Ssc', 'Ath' 'Osa']

rule all:
	input:
		'data/fantom5/PairsLigRec.txt',
		'data/fantom5/ncomms8866-s3.xlsx',
		'data/dlrp/dlrp.txt',
		'data/iuphar/interactions.csv',
		'data/hprd/HPRD_Release9_062910/BINARY_PROTEIN_PROTEIN_INTERACTIONS.txt',
		'data/hgnc/protein-coding_gene.txt',
		expand('data/string/{taxid_string}.protein.links.detailed.{v}.txt.gz',
			taxid_string=TAXID_STRING, v=VERSION_STRING),
		'data/uniprotkb/uniprot_sprot.dat.gz',
		'data/uniprotkb/uniprot_trembl.dat.gz',
		'data/gene2accession/gene2accession.gz',
		expand('data/ensembl/{threename_ensembl}.txt',
			threename_ensembl=THREENAME_ENSEMBL),
		'data/cellphonedb/interaction_input.csv',
		'data/cellphonedb/complex_input.csv',
		'data/baderlab/receptor_ligand_interactions_mitab_v1.0_April2017.txt.zip'
		# 'plot/coverage.png',
		# 'plot/percentage.png',
		# 'id/lrbase/sample_sheet.csv'

rule fantom5:
	output:
		touch('data/fantom5/PairsLigRec.txt'),
		touch('data/fantom5/ncomms8866-s3.xlsx')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/fantom5.txt'
	log:
		'logs/fantom5.log'
	shell:
		'src/fantom5.sh >& {log}'

rule dlrp:
	output:
		touch('data/dlrp/dlrp.txt')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/dlrp.txt'
	log:
		'logs/dlrp.log'
	shell:
		'src/dlrp.sh >& {log}'

rule iuphar:
	output:
		touch('data/iuphar/interactions.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/iuphar.txt'
	log:
		'logs/iuphar.log'
	shell:
		'src/iuphar.sh >& {log}'

rule hprd:
	output:
		'data/hprd/HPRD_Release9_062910/BINARY_PROTEIN_PROTEIN_INTERACTIONS.txt'
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/hprd.txt'
	log:
		'logs/hprd.log'
	shell:
		'src/hprd.sh >& {log}'

rule hgnc:
	output:
		touch('data/hgnc/protein-coding_gene.txt')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/hgnc.txt'
	log:
		'logs/hgnc.log'
	shell:
		'src/hgnc.sh >& {log}'

rule string:
	output:
		touch('data/string/{taxid_string}.protein.links.detailed.{v}.txt.gz')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/string_{v}_{taxid_string}.txt'
	log:
		'logs/string_{v}_{taxid_string}.log'
	shell:
		'src/string.sh {wildcards.v} {wildcards.taxid_string} >& {log}'

rule uniprotkb:
	output:
		touch('data/uniprotkb/uniprot_sprot.dat.gz'),
		touch('data/uniprotkb/uniprot_trembl.dat.gz')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/uniprotkb.txt'
	log:
		'logs/uniprotkb.log'
	shell:
		'src/uniprotkb.sh >& {log}'

rule gene2accession:
	output:
		touch('data/gene2accession/gene2accession.gz')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/gene2accession.txt'
	log:
		'logs/gene2accession.log'
	shell:
		'src/gene2accession.sh >& {log}'

rule ensembl:
	output:
		touch(expand('data/ensembl/{threename_ensembl}.txt',
			threename_ensembl=THREENAME_ENSEMBL))
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/ensembl.txt'
	log:
		'logs/ensembl.log'
	shell:
		'src/ensembl.sh >& {log}'

rule cellphonedb:
	output:
		touch('data/cellphonedb/interaction_input.csv'),
		touch('data/cellphonedb/complex_input.csv')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/cellphonedb.txt'
	log:
		'logs/cellphonedb.log'
	shell:
		'src/cellphonedb.sh >& {log}'

rule baderlab:
	output:
		touch('data/baderlab/receptor_ligand_interactions_mitab_v1.0_April2017.txt.zip')
	conda:
		'envs/myenv.yaml'
	benchmark:
		'benchmarks/baderlab.txt'
	log:
		'logs/baderlab.log'
	shell:
		'src/baderlab.sh >& {log}'

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
