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
		# Venn Diagram
		expand('plot/venndiagram_{db}_9606_{v}_{thr}.png',
			db=['swissprot_string', 'trembl_string'],
			v=VERSION_STRING,
			thr=['low', 'mid', 'high']),
		expand('plot/venndiagram_{db2}.png',
			db2=['swissprot_hprd', 'trembl_hprd']),
		'plot/venndiagram_human.png',
		# Known/Putative ratio
		'plot/known_ratio.png',
		'plot/known_ratio_percentage.png',
		'plot/known_ratio_human.png',
		'plot/known_ratio_human_percentage.png',
		# Phylogenetic tree
		'plot/hclust_human.png',
		# STRING Score plots
		'plot/swissprot_string_score.png',
		'plot/trembl_string_score.png',
		# Summary plots
		'plot/summary.png',
		'plot/summary_percentage.png',
		# Change by year
		'plot/swissprot.png',
		'plot/trembl.png',
		'plot/string_protein.png',
		'plot/string_ppi.png'

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
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/plot_string_score.txt'
	log:
		'logs/plot_string_score.log'
	shell:
		'src/plot_string_score.sh {input} >& {log}'

rule plot_venndiagram_uniprotkb_string:
	input:
		'data/{db}/9606_{v}_{thr}.csv',
		'data/csv/9606.csv'
	output:
		'plot/venndiagram_{db}_9606_{v}_{thr}.png'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/plot_venndiagram_uniprotkb_string_{db}_{v}_{thr}.txt'
	log:
		'logs/plot_venndiagram_uniprotkb_string_{db}_{v}_{thr}.log'
	shell:
		'src/plot_venndiagram_uniprotkb_string.sh {input} {output} >& {log}'

rule plot_venndiagram_uniprotkb_hprd:
	input:
		'data/{db2}/9606.csv',
		'data/csv/9606.csv'
	output:
		'plot/venndiagram_{db2}.png'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/plot_venndiagram_uniprotkb_hprd_{db2}.txt'
	log:
		'logs/plot_venndiagram_uniprotkb_hprd_{db2}.log'
	shell:
		'src/plot_venndiagram_uniprotkb_hprd.sh {input} {output} >& {log}'

rule plot_venndiagram_human:
	input:
		'data/csv/9606.csv'
	output:
		'plot/venndiagram_human.png'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/plot_venndiagram_human.txt'
	log:
		'logs/plot_venndiagram_human.log'
	shell:
		'src/plot_venndiagram_human.sh >& {log}'

rule plot_hclust_human:
	input:
		'data/csv/9606.csv'
	output:
		'plot/hclust_human.png'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/plot_hclust_human.txt'
	log:
		'logs/plot_hclust_human.log'
	shell:
		'src/plot_hclust_human.sh >& {log}'

rule plot_known_ratio_human:
	input:
		'data/csv/9606.csv'
	output:
		'plot/known_ratio_human.png',
		'plot/known_ratio_human_percentage.png'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/plot_known_ratio_human.txt'
	log:
		'logs/plot_known_ratio_human.log'
	shell:
		'src/plot_known_ratio_human.sh >& {log}'

rule plot_known_ratio:
	input:
		'sample_sheet/sample_sheet.csv',
		expand('data/csv/{taxid_all}.csv',
			taxid_all=TAXID_ALL)
	output:
		'plot/known_ratio.png',
		'plot/known_ratio_percentage.png'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/plot_known_ratio.txt'
	log:
		'logs/plot_known_ratio.log'
	shell:
		'src/plot_known_ratio.sh >& {log}'

rule plot_summary:
	input:
		'data/summary.RData'
	output:
		'plot/summary.png',
		'plot/summary_percentage.png'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/plot_summary.txt'
	log:
		'logs/plot_summary.log'
	shell:
		'src/plot_summary.sh >& {log}'

rule plot_swissprot:
	output:
		'plot/swissprot.png'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/plot_swissprot.txt'
	log:
		'logs/plot_swissprot.log'
	shell:
		'src/plot_swissprot.sh >& {log}'

rule plot_trembl:
	output:
		'plot/trembl.png'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/plot_trembl.txt'
	log:
		'logs/plot_trembl.log'
	shell:
		'src/plot_trembl.sh >& {log}'

rule plot_string:
	output:
		'plot/string_protein.png',
		'plot/string_ppi.png'
	container:
		'docker://koki/workflow:20210327'
	benchmark:
		'benchmarks/plot_string.txt'
	log:
		'logs/plot_string.log'
	shell:
		'src/plot_string.sh >& {log}'