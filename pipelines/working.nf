/*
 * Defines some parameters in order to specify the refence genomes
 */

// Pipeline version
version = 'n + 1'

params.help            = false
params.resume          = false

log.info """

====================================================
GS - G4500_workflow - N F  ~  version ${version}
====================================================
REPO_LOCATION                 : ${params.REPO_LOCATION}
BWA_REPO                      : ${params.BWA_REPO}
SPECIES                       : ${params.SPECIES}
REF                           : ${params.REF}
TARGET_REPO                   : ${params.TARGET_REPO}
GENE_PANEL                    : ${params.GENE_PANEL}
GENOME_REPO                   : ${params.GENOME_REPO}
VEP_DATA                      : ${params.VEP_DATA}
Rscript_from_anh_DUY          : ${params.Rscript_from_anh_DUY}
VERSION                       : ${params.VERSION}
INDIR                         : ${params.INDIR}
READS                         : ${params.READS}
INPUT_PAIRS                   : ${params.INPUT_PAIRS}
OUTDIR                        : ${params.OUTDIR}
"""

if (params.help) exit 1
if (params.resume) exit 1, "LOL! Are you making the classical --resume typo? :))))))"

BWA_REPO_FOLDER = file("${params.BWA_REPO}")
GENOME_REPO_FOLDER = file("${params.GENOME_REPO}")
TARGET_REPO_FOLDER = file("${params.TARGET_REPO}")

WORKING_FOLDER = file("${params.VEP_DATA}")
R_SCRIPT = file("${params.Rscript_from_anh_DUY}")

Channel
    .fromFilePairs( params.INPUT_PAIRS )
    .ifEmpty { error "Cannot find any reads matching: ${params.INPUT_PAIRS}"  }
    .into {reads_preqc; reads_trimming}


// -----------------------------------------------------------------------------
//              PRE-PIPELINE QC
// -----------------------------------------------------------------------------

process fastqc {
    cache "deep"; tag "FASTQC on $sample_id"
    publishDir "${params.OUTDIR}/${sample_id}/fastqc", mode: 'copy'

    input:
        tuple sample_id, file(INPUT_PAIRS) from reads_preqc

    output:
        tuple sample_id, '*_fastqc.{zip,html}' into preqc_results

    script:
        template 'fastqc/fastqc.sh'
}

// -----------------------------------------------------------------------------
//                BEGIN PIPELINE
// -----------------------------------------------------------------------------

/*
** Trimming
*/
process trim {
    cache "deep"; tag "BBduk on $sample_id"
    publishDir "${params.OUTDIR}/${sample_id}/trim75", mode: 'copy'

    input:
        tuple sample_id, file(INPUT_PAIRS) from reads_trimming

    output:
        tuple sample_id, "${sample_id}_*_trim75.fastq.gz" into trimmed_reads

    script:
          template 'bbmap/bbduk.sh'
} 

/*
** Mapping
*/

process align_bwa {

    //storeDir "/Volumes/GSHD15/storeDir_test20k"

    cache "deep"; tag "bwa on $sample_id"
    publishDir "${params.OUTDIR}/${sample_id}/align_bwa", mode: "copy"

    input:
        tuple sample_id, "${sample_id}_*_trim75.fastq.gz" from trimmed_reads
        file BWA_REPO_FOLDER

    output:
        tuple sample_id, "${sample_id}.sam" into mapping_results

    script:
        template 'bwa/bwa_mem.sh'
}

/*
** Sorting
*/

process picard {
    cache "deep"; tag "picard on $sample_id"
    publishDir "${params.OUTDIR}/${sample_id}/picard", mode: "copy"

    input:
        tuple sample_id, "${sample_id}.sam" from mapping_results
        file GENOME_REPO_FOLDER

    output:
        tuple sample_id, "${sample_id}_sorted.bam" into picard_SortSam_ch
        tuple sample_id, "${sample_id}_dedup_metrics.txt", "${sample_id}_dedup.bam", "${sample_id}_dedup.bai" into picard_MarkDuplicates_ch
        tuple "${sample_id}_alignment_metrics.txt", "${sample_id}_insert_metrics.txt", "${sample_id}_histogram.pdf"

    script:
        template 'picard/picard.sh'
}

process bedtools_coverage {
    cache "deep"; tag "bedtools coverage on $sample_id"
    publishDir "${params.OUTDIR}/${sample_id}/bedtools_coverage", mode: "copy"

    input:
        tuple sample_id, "${sample_id}_sorted.bam" from picard_SortSam_ch
        file TARGET_REPO_FOLDER

    output:
        file ("${sample_id}_cov_per_gene.txt")

    script:
        template 'bedtools/bedtools_coverage.sh'
}

/*
** Duplicating
*/

// process picard_MarkDuplicates {
//     cache "deep"; tag "picard MarkDuplicates on $sample_id"
//     publishDir "${params.OUTDIR}/${sample_id}/picard_MarkDuplicates", mode: "copy"

//     input:
//         tuple sample_id, "${sample_id}_sorted.bam" from picard_SortSam_ch

//     output:
//         tuple sample_id, "${sample_id}_dedup_metrics.txt", "${sample_id}_dedup.bam", "${sample_id}_dedup.bai" into picard_MarkDuplicates_ch

//     script:
//         template 'picard/picard_MarkDuplicates.sh'
// }

/*
** Calling germline small variants
*/

process strelka {
    cache "deep"; tag "Calling small variants on $sample_id"
    publishDir "${params.OUTDIR}/${sample_id}/strelka", mode: "copy"
      
    input:
        tuple sample_id, "${sample_id}_dedup_metrics.txt", "${sample_id}_dedup.bam", "${sample_id}_dedup.bai" from picard_MarkDuplicates_ch
        file BWA_REPO_FOLDER
        file TARGET_REPO_FOLDER

    output:
        tuple sample_id, file("${sample_id}_strelka") into strelka_ch

    script:
        template 'strelka/strelka.sh'
}

/*
** Determining the effect of variants
*/

process vep {
    cache "deep"; tag "Determining the effect of the variants of $sample_id"
    publishDir "${params.OUTDIR}/${sample_id}/vep", mode: "copy"

    input:
        tuple sample_id, file("${sample_id}_strelka") from strelka_ch
        file WORKING_FOLDER

    output:
        tuple sample_id, "${sample_id}_vep98.txt" into vep_ch
        file "${sample_id}_gnomAD_EAS_AF_0_3_filtered.txt"

    script:
        template 'vep/vep.sh'
}

process vep_filter_using_R {
    cache "deep"; tag "Filtering by using R on $sample_id"
    publishDir "${params.OUTDIR}/${sample_id}/vep_filter_using_R", mode: "copy"

    input:
        tuple sample_id, "${sample_id}_vep98.txt" from vep_ch
        file R_SCRIPT

    output:
        file("${sample_id}_filtered_vep98.tsv") into r_ch

    script:
        template 'vep_filter_using_R/syntax.sh'
}

// -----------------------------------------------------------------------------

workflow.onComplete {

    println ( workflow.success ? """
        Pipeline execution summary
        ---------------------------
        Started at  : ${workflow.start}
        Completed at: ${workflow.complete}
        Duration    : ${workflow.duration}
        Success     : ${workflow.success}
        workDir     : ${workflow.workDir}
        exit status : ${workflow.exitStatus}
        """ : """
        Failed: ${workflow.errorReport}
        exit status : ${workflow.exitStatus}
        """
    )
}
