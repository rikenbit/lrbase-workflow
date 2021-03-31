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
		expand('data/ensembl_dlrp/{taxid_ensembl}.csv',
				taxid_ensembl=TAXID_ENSEMBL),
		expand('data/ensembl_iuphar/{taxid_ensembl}.csv',
				taxid_ensembl=TAXID_ENSEMBL),
		expand('data/ensembl_hpmr/{taxid_ensembl}.csv',
				taxid_ensembl=TAXID_ENSEMBL),
		expand('data/ensembl_cellphonedb/{taxid_ensembl}.csv',
				taxid_ensembl=TAXID_ENSEMBL),
		expand('data/ensembl_singlecellsignalr/{taxid_ensembl}.csv',
				taxid_ensembl=TAXID_ENSEMBL),

		expand('data/ncbi_dlrp/{taxid_ncbi}.csv',
				taxid_ncbi=TAXID_NCBI),
		expand('data/ncbi_iuphar/{taxid_ncbi}.csv',
				taxid_ncbi=TAXID_NCBI),
		expand('data/ncbi_hpmr/{taxid_ncbi}.csv',
				taxid_ncbi=TAXID_NCBI),
		expand('data/ncbi_cellphonedb/{taxid_ncbi}.csv',
				taxid_ncbi=TAXID_NCBI),
		expand('data/ncbi_singlecellsignalr/{taxid_ncbi}.csv',
				taxid_ncbi=TAXID_NCBI),

		expand('data/rbbh_dlrp/{taxid_rbbh}.csv',
				taxid_rbbh=TAXID_RBBH),
		expand('data/rbbh_iuphar/{taxid_rbbh}.csv',
				taxid_rbbh=TAXID_RBBH),
		expand('data/rbbh_hpmr/{taxid_rbbh}.csv',
				taxid_rbbh=TAXID_RBBH),
		expand('data/rbbh_cellphonedb/{taxid_rbbh}.csv',
				taxid_rbbh=TAXID_RBBH),
		expand('data/rbbh_singlecellsignalr/{taxid_rbbh}.csv',
				taxid_rbbh=TAXID_RBBH)

#############################################
# Preprocess
#############################################
rule preprocess_homologene:
	input:
		'data/homologene/homologene.data'
	output:
		'data/homologene/{taxid_ncbi}.csv'
	container:
		'docker://koki/workflow:20210327'
	wildcard_constraints:
		taxid_ncbi='|'.join([re.escape(x) for x in TAXID_NCBI])
	benchmark:
		'benchmarks/preprocess_homologene_{taxid_ncbi}.txt'
	log:
		'logs/preprocess_homologene_{taxid_ncbi}.log'
	shell:
		'src/preprocess_homologene.sh {wildcards.taxid_ncbi} {output} >& {log}'

# Ensembl based
rule preprocess_ensembl_dlrp:
	input:
		'data/biomart/{taxid_ensembl}.csv',
		'data/dlrp/pre_dlrp2.csv'
	output:
		'data/ensembl_dlrp/{taxid_ensembl}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ensembl_dlrp_{taxid_ensembl}.txt'
	log:
		'logs/preprocess_ensembl_dlrp_{taxid_ensembl}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} ENSEMBL_DLRP >& {log}'

rule preprocess_ensembl_iuphar:
	input:
		'data/biomart/{taxid_ensembl}.csv',
		'data/iuphar/iuphar.csv'
	output:
		'data/ensembl_iuphar/{taxid_ensembl}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ensembl_iuphar_{taxid_ensembl}.txt'
	log:
		'logs/preprocess_ensembl_iuphar_{taxid_ensembl}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} ENSEMBL_IUPHAR >& {log}'

rule preprocess_ensembl_hpmr:
	input:
		'data/biomart/{taxid_ensembl}.csv',
		'data/hpmr/hpmr.csv'
	output:
		'data/ensembl_hpmr/{taxid_ensembl}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ensembl_hpmr_{taxid_ensembl}.txt'
	log:
		'logs/preprocess_ensembl_hpmr_{taxid_ensembl}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} ENSEMBL_HPMR >& {log}'

rule preprocess_ensembl_cellphonedb:
	input:
		'data/biomart/{taxid_ensembl}.csv',
		'data/cellphonedb/cellphonedb.csv'
	output:
		'data/ensembl_cellphonedb/{taxid_ensembl}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ensembl_cellphonedb_{taxid_ensembl}.txt'
	log:
		'logs/preprocess_ensembl_cellphonedb_{taxid_ensembl}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} ENSEMBL_CELLPHONEDB >& {log}'

rule preprocess_ensembl_singlecellsignalr:
	input:
		'data/biomart/{taxid_ensembl}.csv',
		'data/singlecellsignalr/lrdb.csv'
	output:
		'data/ensembl_singlecellsignalr/{taxid_ensembl}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ensembl_singlecellsignalr_{taxid_ensembl}.txt'
	log:
		'logs/preprocess_ensembl_singlecellsignalr_{taxid_ensembl}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} ENSEMBL_SINGLECELLSIGNALR >& {log}'

# NCBI Homologene based
rule preprocess_ncbi_dlrp:
	input:
		'data/homologene/{taxid_ncbi}.csv',
		'data/dlrp/pre_dlrp2.csv'
	output:
		'data/ncbi_dlrp/{taxid_ncbi}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ncbi_dlrp_{taxid_ncbi}.txt'
	log:
		'logs/preprocess_ncbi_dlrp_{taxid_ncbi}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} NCBI_DLRP >& {log}'

rule preprocess_ncbi_iuphar:
	input:
		'data/homologene/{taxid_ncbi}.csv',
		'data/iuphar/iuphar.csv'
	output:
		'data/ncbi_iuphar/{taxid_ncbi}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ncbi_iuphar_{taxid_ncbi}.txt'
	log:
		'logs/preprocess_ncbi_iuphar_{taxid_ncbi}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} NCBI_IUPHAR >& {log}'

rule preprocess_ncbi_hpmr:
	input:
		'data/homologene/{taxid_ncbi}.csv',
		'data/hpmr/hpmr.csv'
	output:
		'data/ncbi_hpmr/{taxid_ncbi}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ncbi_hpmr_{taxid_ncbi}.txt'
	log:
		'logs/preprocess_ncbi_hpmr_{taxid_ncbi}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} NCBI_HPMR >& {log}'

rule preprocess_ncbi_cellphonedb:
	input:
		'data/homologene/{taxid_ncbi}.csv',
		'data/cellphonedb/cellphonedb.csv'
	output:
		'data/ncbi_cellphonedb/{taxid_ncbi}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ncbi_cellphonedb_{taxid_ncbi}.txt'
	log:
		'logs/preprocess_ncbi_cellphonedb_{taxid_ncbi}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} NCBI_CELLPHONEDB >& {log}'

rule preprocess_ncbi_singlecellsignalr:
	input:
		'data/homologene/{taxid_ncbi}.csv',
		'data/singlecellsignalr/lrdb.csv'
	output:
		'data/ncbi_singlecellsignalr/{taxid_ncbi}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ncbi_singlecellsignalr_{taxid_ncbi}.txt'
	log:
		'logs/preprocess_ncbi_singlecellsignalr_{taxid_ncbi}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} NCBI_SINGLECELLSIGNALR >& {log}'

# RBBH based
# From meshr-pipeline
def rbbh_threename_file(wld):
	idx=TAXID_RBBH.to_numpy().tolist().index(wld.taxid_rbbh)
	return('data/rbbh/' + THREENAME_RBBH[idx] + '.txt')

rule preprocess_rbbh:
	input:
		rbbh_threename_file
	output:
		'data/rbbh/{taxid_rbbh}.csv'
	wildcard_constraints:
		taxid_rbbh='|'.join([re.escape(x) for x in TAXID_RBBH])
	benchmark:
		'benchmarks/preprocess_rbbh_{taxid_rbbh}.txt'
	log:
		'logs/preprocess_rbbh_{taxid_rbbh}.log'
	shell:
		'src/preprocess_rbbh.sh {input} {output} >& {log}'

rule preprocess_rbbh_dlrp:
	input:
		'data/rbbh/{taxid_rbbh}.csv',
		'data/dlrp/pre_dlrp2.csv'
	output:
		'data/rbbh_dlrp/{taxid_rbbh}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_rbbh_dlrp_{taxid_rbbh}.txt'
	log:
		'logs/preprocess_rbbh_dlrp_{taxid_rbbh}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} RBBH_DLRP >& {log}'

rule preprocess_rbbh_iuphar:
	input:
		'data/rbbh/{taxid_rbbh}.csv',
		'data/iuphar/iuphar.csv'
	output:
		'data/rbbh_iuphar/{taxid_rbbh}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_rbbh_iuphar_{taxid_rbbh}.txt'
	log:
		'logs/preprocess_rbbh_iuphar_{taxid_rbbh}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} RBBH_IUPHAR >& {log}'

rule preprocess_rbbh_hpmr:
	input:
		'data/rbbh/{taxid_rbbh}.csv',
		'data/hpmr/hpmr.csv'
	output:
		'data/rbbh_hpmr/{taxid_rbbh}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_rbbh_hpmr_{taxid_rbbh}.txt'
	log:
		'logs/preprocess_rbbh_hpmr_{taxid_rbbh}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} RBBH_HPMR >& {log}'

rule preprocess_rbbh_cellphonedb:
	input:
		'data/rbbh/{taxid_rbbh}.csv',
		'data/cellphonedb/cellphonedb.csv'
	output:
		'data/rbbh_cellphonedb/{taxid_rbbh}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_rbbh_cellphonedb_{taxid_rbbh}.txt'
	log:
		'logs/preprocess_rbbh_cellphonedb_{taxid_rbbh}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} RBBH_CELLPHONEDB >& {log}'

rule preprocess_rbbh_singlecellsignalr:
	input:
		'data/rbbh/{taxid_rbbh}.csv',
		'data/singlecellsignalr/lrdb.csv'
	output:
		'data/rbbh_singlecellsignalr/{taxid_rbbh}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_rbbh_singlecellsignalr_{taxid_rbbh}.txt'
	log:
		'logs/preprocess_rbbh_singlecellsignalr_{taxid_rbbh}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} RBBH_SINGLECELLSIGNALR >& {log}'