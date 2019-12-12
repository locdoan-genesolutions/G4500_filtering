picard SortSam \\
INPUT=${sample_id}.sam \\
OUTPUT=${sample_id}_sorted.bam \\
SORT_ORDER=coordinate \\
use_jdk_deflater=true use_jdk_inflater=true;

picard MarkDuplicates \\
INPUT=${sample_id}_sorted.bam \\
OUTPUT=${sample_id}_dedup.bam METRICS_FILE=${sample_id}_dedup_metrics.txt \\
use_jdk_deflater=true use_jdk_inflater=true;

picard BuildBamIndex INPUT=${sample_id}_dedup.bam;

picard CollectAlignmentSummaryMetrics \\
R=${GENOME_REPO_FOLDER}/${params.REF} \\
I=${sample_id}_sorted.bam \\
O=${sample_id}_alignment_metrics.txt;

picard CollectInsertSizeMetrics \\
INPUT=${sample_id}_sorted.bam \\
OUTPUT=${sample_id}_insert_metrics.txt \\
HISTOGRAM_FILE=${sample_id}_histogram.pdf