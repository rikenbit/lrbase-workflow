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
		expand('data/ensembl_fantom5/{taxid_ensembl}.csv',
				taxid_ensembl=TAXID_ENSEMBL,
                                taxid_putative=TAXID_PUTATIVE,),
		expand('data/ensembl_baderlab/{taxid_ensembl}.csv',
				taxid_ensembl=TAXID_ENSEMBL),
		expand('data/ensembl_swissprot_hprd/{taxid_ensembl}.csv',
				taxid_ensembl=TAXID_ENSEMBL),
		expand('data/ensembl_trembl_hprd/{taxid_ensembl}.csv',
				taxid_ensembl=TAXID_ENSEMBL),

		expand('data/ncbi_fantom5/{taxid_ncbi}.csv',
				taxid_ncbi=TAXID_NCBI),
		expand('data/ncbi_baderlab/{taxid_ncbi}.csv',
				taxid_ncbi=TAXID_NCBI),
		expand('data/ncbi_swissprot_hprd/{taxid_ncbi}.csv',
				taxid_ncbi=TAXID_NCBI),
		expand('data/ncbi_trembl_hprd/{taxid_ncbi}.csv',
				taxid_ncbi=TAXID_NCBI),

		expand('data/rbbh_fantom5/{taxid_rbbh}.csv',
				taxid_rbbh=TAXID_RBBH),
		expand('data/rbbh_baderlab/{taxid_rbbh}.csv',
				taxid_rbbh=TAXID_RBBH),
		expand('data/rbbh_swissprot_hprd/{taxid_rbbh}.csv',
				taxid_rbbh=TAXID_RBBH),
		expand('data/rbbh_trembl_hprd/{taxid_rbbh}.csv',
				taxid_rbbh=TAXID_RBBH),

		expand('data/uniprotkb/swissprot_{taxid_putative}_secreted.csv',
				taxid_putative=TAXID_PUTATIVE),
		expand('data/uniprotkb/swissprot_{taxid_putative}_membrane.csv',
				taxid_putative=TAXID_PUTATIVE),

		expand('data/uniprotkb/trembl_{taxid_putative}_secreted.csv',
				taxid_putative=TAXID_PUTATIVE),
		expand('data/uniprotkb/trembl_{taxid_putative}_membrane.csv',
				taxid_putative=TAXID_PUTATIVE)

#############################################
# Preprocess
#############################################
# Preprocess of SWISSPROT
rule preprocess_swissprot:
	input:
		'data/uniprotkb/uniprot_sprot.dat'
	output:
		'data/uniprotkb/swissprot_{taxid_putative}.csv'
	container:
		'docker://julia:1.6.0-rc1-buster'
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE])
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
		'data/uniprotkb/swissprot_{taxid_putative}_secreted.csv'
	container:
		'docker://koki/workflow:20210327'
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE])
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
		'data/uniprotkb/swissprot_{taxid_putative}_membrane.csv'
	container:
		'docker://koki/workflow:20210327'
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE])
	benchmark:
		'benchmarks/preprocess_swissprot_{taxid_putative}_membrane.txt'
	log:
		'logs/preprocess_swissprot_{taxid_putative}_membrane.log'
	shell:
		'src/preprocess_swissprot_membrane.sh {wildcards.taxid_putative} >& {log}'

rule preprocess_swissprot_hprd:
	input:
		'data/ensembl/9606_symbol.txt',
		'data/uniprotkb/swissprot_9606_secreted.csv',
		'data/uniprotkb/swissprot_9606_membrane.csv',
		'data/hprd/HPRD_Release9_062910/BINARY_PROTEIN_PROTEIN_INTERACTIONS.txt'
	output:
		'data/swissprot_hprd/9606.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_swissprot_hprd.txt'
	log:
		'logs/preprocess_swissprot_hprd.log'
	shell:
		'src/preprocess_swissprot_hprd.sh >& {log}'

# Preprocess of TrEMBL
rule preprocess_trembl:
	input:
		'data/uniprotkb/uniprot_trembl.dat'
	output:
		'data/uniprotkb/trembl_{taxid_putative}.csv'
	container:
		'docker://julia:1.6.0-rc1-buster'
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE])
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
		'data/uniprotkb/trembl_{taxid_putative}_secreted.csv'
	container:
		'docker://koki/workflow:20210327'
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE])
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
		'data/uniprotkb/trembl_{taxid_putative}_membrane.csv'
	container:
		'docker://koki/workflow:20210327'
	wildcard_constraints:
		taxid_putative='|'.join([re.escape(x) for x in TAXID_PUTATIVE])
	benchmark:
		'benchmarks/preprocess_trembl_{taxid_putative}_membrane.txt'
	log:
		'logs/preprocess_trembl_{taxid_putative}_membrane.log'
	shell:
		'src/preprocess_trembl_membrane.sh {wildcards.taxid_putative} >& {log}'

rule preprocess_trembl_hprd:
	input:
		'data/ensembl/9606_symbol.txt',
		'data/uniprotkb/trembl_9606_secreted.csv',
		'data/uniprotkb/trembl_9606_membrane.csv',
		'data/hprd/HPRD_Release9_062910/BINARY_PROTEIN_PROTEIN_INTERACTIONS.txt'
	output:
		'data/trembl_hprd/9606.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_trembl_hprd.txt'
	log:
		'logs/preprocess_trembl_hprd.log'
	shell:
		'src/preprocess_trembl_hprd.sh >& {log}'

# Ensembl + Putative based
rule preprocess_ensembl_fantom5:
	input:
		'data/biomart/{taxid_ensembl}.csv',
		'data/fantom5/fantom5.csv'
	output:
		'data/ensembl_fantom5/{taxid_ensembl}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ensembl_fantom5_{taxid_ensembl}.txt'
	log:
		'logs/preprocess_ensembl_fantom5_{taxid_ensembl}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} ENSEMBL_FANTOM5 >& {log}'

rule preprocess_ensembl_baderlab:
	input:
		'data/biomart/{taxid_ensembl}.csv',
		'data/baderlab/baderlab.csv'
	output:
		'data/ensembl_baderlab/{taxid_ensembl}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ensembl_baderlab_{taxid_ensembl}.txt'
	log:
		'logs/preprocess_ensembl_baderlab_{taxid_ensembl}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} ENSEMBL_BADERLAB >& {log}'

rule preprocess_ensembl_swissprot_hprd:
	input:
		'data/biomart/{taxid_ensembl}.csv',
		'data/swissprot_hprd/9606.csv'
	output:
		'data/ensembl_swissprot_hprd/{taxid_ensembl}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ensembl_swissprot_hprd_{taxid_ensembl}.txt'
	log:
		'logs/preprocess_ensembl_swissprot_hprd_{taxid_ensembl}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} ENSEMBL_SWISSPROT_HPRD >& {log}'

rule preprocess_ensembl_trembl_hprd:
	input:
		'data/biomart/{taxid_ensembl}.csv',
		'data/trembl_hprd/9606.csv'
	output:
		'data/ensembl_trembl_hprd/{taxid_ensembl}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ensembl_trembl_hprd_{taxid_ensembl}.txt'
	log:
		'logs/preprocess_ensembl_trembl_hprd_{taxid_ensembl}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} ENSEMBL_TREMBL_HPRD >& {log}'

# NCBI Homologene + Putative based
rule preprocess_ncbi_fantom5:
	input:
		'data/homologene/{taxid_ncbi}.csv',
		'data/fantom5/fantom5.csv'
	output:
		'data/ncbi_fantom5/{taxid_ncbi}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ncbi_fantom5_{taxid_ncbi}.txt'
	log:
		'logs/preprocess_ncbi_fantom5_{taxid_ncbi}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} NCBI_FANTOM5 >& {log}'

rule preprocess_ncbi_baderlab:
	input:
		'data/homologene/{taxid_ncbi}.csv',
		'data/baderlab/baderlab.csv'
	output:
		'data/ncbi_baderlab/{taxid_ncbi}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ncbi_baderlab_{taxid_ncbi}.txt'
	log:
		'logs/preprocess_ncbi_baderlab_{taxid_ncbi}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} NCBI_BADERLAB >& {log}'

rule preprocess_ncbi_swissprot_hprd:
	input:
		'data/homologene/{taxid_ncbi}.csv',
		'data/swissprot_hprd/9606.csv'
	output:
		'data/ncbi_swissprot_hprd/{taxid_ncbi}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ncbi_swissprot_hprd_{taxid_ncbi}.txt'
	log:
		'logs/preprocess_ncbi_swissprot_hprd_{taxid_ncbi}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} NCBI_SWISSPROT_HPRD >& {log}'

rule preprocess_ncbi_trembl_hprd:
	input:
		'data/homologene/{taxid_ncbi}.csv',
		'data/trembl_hprd/9606.csv'
	output:
		'data/ncbi_trembl_hprd/{taxid_ncbi}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_ncbi_trembl_hprd_{taxid_ncbi}.txt'
	log:
		'logs/preprocess_ncbi_trembl_hprd_{taxid_ncbi}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} NCBI_TREMBL_HPRD >& {log}'

# RBBH + Putative based
rule preprocess_rbbh_fantom5:
	input:
		'data/rbbh/{taxid_rbbh}.csv',
		'data/fantom5/fantom5.csv'
	output:
		'data/rbbh_fantom5/{taxid_rbbh}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_rbbh_fantom5_{taxid_rbbh}.txt'
	log:
		'logs/preprocess_rbbh_fantom5_{taxid_rbbh}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} RBBH_FANTOM5 >& {log}'

rule preprocess_rbbh_baderlab:
	input:
		'data/rbbh/{taxid_rbbh}.csv',
		'data/baderlab/baderlab.csv'
	output:
		'data/rbbh_baderlab/{taxid_rbbh}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_rbbh_baderlab_{taxid_rbbh}.txt'
	log:
		'logs/preprocess_rbbh_baderlab_{taxid_rbbh}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} RBBH_BADERLAB >& {log}'

rule preprocess_rbbh_swissprot_hprd:
	input:
		'data/rbbh/{taxid_rbbh}.csv',
		'data/swissprot_hprd/9606.csv'
	output:
		'data/rbbh_swissprot_hprd/{taxid_rbbh}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_rbbh_swissprot_hprd_{taxid_rbbh}.txt'
	log:
		'logs/preprocess_rbbh_swissprot_hprd_{taxid_rbbh}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} RBBH_SWISSPROT_HPRD >& {log}'

rule preprocess_rbbh_trembl_hprd:
	input:
		'data/rbbh/{taxid_rbbh}.csv',
		'data/trembl_hprd/9606.csv'
	output:
		'data/rbbh_trembl_hprd/{taxid_rbbh}.csv'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/preprocess_rbbh_trembl_hprd_{taxid_rbbh}.txt'
	log:
		'logs/preprocess_rbbh_trembl_hprd_{taxid_rbbh}.log'
	shell:
		'src/preprocess_ortholog_ppi.sh {input} {output} RBBH_TREMBL_HPRD >& {log}'
