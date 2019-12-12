bedtools coverage -b \\
${sample_id}_sorted.bam -a \\
${TARGET_REPO_FOLDER}/${params.GENE_PANEL} > ${sample_id}_cov_per_gene.txt