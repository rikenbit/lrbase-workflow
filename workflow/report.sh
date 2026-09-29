# HTML
mkdir -p report
mkdir -p report/v012
snakemake -s workflow/download.smk --report report/v012/download.html
snakemake -s workflow/preprocess_known_human.smk --report report/v012/preprocess_known_human.html
snakemake -s workflow/preprocess_known_otherspecies.smk --report report/v012/preprocess_known_otherspecies.html
snakemake -s workflow/preprocess_putative_human.smk --report report/v012/preprocess_putative_human.html
snakemake -s workflow/preprocess_putative_otherspecies.smk --report report/v012/preprocess_putative_otherspecies.html
snakemake -s workflow/preprocess_putative_allspecies.smk --report report/v012/preprocess_putative_allspecies.html
snakemake -s workflow/csv.smk --report report/v012/csv.html
snakemake -s workflow/sqlite.smk --report report/v012/sqlite.html
snakemake -s workflow/metadata.smk --report report/v012/metadata.html
snakemake -s workflow/plot.smk --report report/v012/plot.html
