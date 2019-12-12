bwa mem -t 4 -M -R \\
'@RG\\tID:${sample_id}\\tLB:${sample_id}\\tPL:ILLUMINA\\tPM:MINISEQ\\tSM:${sample_id}' \\
${BWA_REPO_FOLDER}/${params.REF} \\
${sample_id}_*_trim75.fastq.gz > ${sample_id}.sam