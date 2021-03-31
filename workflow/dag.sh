# DAG graph
snakemake -s workflow/download.smk --rulegraph | dot -Tpng > plot/download.png
snakemake -s workflow/preprocess_known_human.smk --rulegraph | dot -Tpng > plot/preprocess_known_human.png
snakemake -s workflow/preprocess_known_otherspecies.smk --rulegraph | dot -Tpng > plot/preprocess_known_otherspecies.png
snakemake -s workflow/preprocess_putative_human.smk --rulegraph | dot -Tpng > plot/preprocess_putative_human.png
snakemake -s workflow/preprocess_putative_otherspecies.smk --rulegraph | dot -Tpng > plot/preprocess_putative_otherspecies.png
snakemake -s workflow/preprocess_putative_allspecies.smk --rulegraph | dot -Tpng > plot/preprocess_putative_allspecies.png
snakemake -s workflow/csv.smk --rulegraph | dot -Tpng > plot/csv.png
snakemake -s workflow/sqlite.smk --rulegraph | dot -Tpng > plot/sqlite.png
snakemake -s workflow/metadata.smk --rulegraph | dot -Tpng > plot/metadata.png
snakemake -s workflow/plot.smk --rulegraph | dot -Tpng > plot/plot.png