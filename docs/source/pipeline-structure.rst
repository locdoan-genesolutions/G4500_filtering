.. _pipeline-structure-page:

Pipeline Structure
==================


   
The file paths for all data fed to a pipeline are specified in the configuration file.

Users must provide the following files:
    - Sequencing files
    - SPECIES for Burrows-Wheeler Aligner and Strelka process
    - GENE_PANEL for Strelka process
    - fasta, custom, dbNSFP4.0c folders for VEP process
    - rscript from anh DUY

Configuration File
------------------

The configuration file is where all file paths are specified and pipeline processes are paramaterized. The configuration can be broken into two sections, including file paths, compute resources.

File Paths
``````````
The configuration file specifies where to find all of the input data. Additionally, it provides a path to an output directory where the pipeline will output results. The following is a typical example for the G4500_workflow configuration file::

    INDIR  = "/Volumes/GSSD01/repo/testing_strelka/G4500_raw"
    OUTDIR = "/Volumes/GSSD01/output"

    reads = "${params.INDIR}/*_R{1,2}_*.fastq.gz"
    
    REPO_LOCATION = "/Volumes/GSSD01/repo/resources"
    BWA_REPO = "$REPO_LOCATION/bwa"
    //GENOME_REPO = '$REPO_LOCATION/genomes'
    TARGET_REPO = "$REPO_LOCATION/target_genes"
    SPECIES = "hg38_selected.fa"
    GENE_PANEL = "sorted_G4500.targets.hg38.bed.gz"
    VEP_DATA = "/Volumes/GSSD01/vep_data"
    Rscript_from_anh_DUY = "/Volumes/GSSD01/vep_data/r_script/vep_filter_EASAF.R"

Pipeline Script
---------------

Template Processes
------------------

Pipelines written in `Nextflow` consist of a series of processes. Processes specify data I/O and typically wrap around third-party software tools to process this data. Processes are connected through channels – asynchronous FIFO queues – which manage the flow of data throughout the pipeline.

Processes have the following basic structure::
    
    process <name> {

        input:
        <process inputs>

        output:
        <process outputs>

        script:
        <user script to be executed>
    }


Often, the script portion of the processes are reused by various sequencing pipelines. To help standardize pipeline development and ensure good practices are propogated to all pipelines, template processes are defined and inherited by pipeline processes.

.. note:: Templates are located in **pipelines/templates**

For example, these two processes execute the same code::

    # Without inheritance
    process fastqc {
    
      cache "deep"; tag "FASTQC on $sample_id"
      publishDir "${params.OUTDIR}/${sample_id}/fastqc", mode: 'copy'

      input:
         tuple sample_id, file(reads) from reads_preqc

      output:
         tuple sample_id, '*_fastqc.{zip,html}' into preqc_results
 
      script:
         '''
         fastqc --quiet --outdir . ${reads[0]} ${reads[1]}
         '''
         
   }

    # With inheritance
    process fastqc {
    
      cache "deep"; tag "FASTQC on $sample_id"
      publishDir "${params.OUTDIR}/${sample_id}/fastqc", mode: 'copy'

      input:
         tuple sample_id, file(reads) from reads_preqc

      output:
         tuple sample_id, '*_fastqc.{zip,html}' into preqc_results

      script:
         template 'fastqc/paired.sh'
   }

Output
------

The G4500 pipeline output has the following basic structure::

         /output
         │
         ├── 47-G1314_S47
         │   ├── align_bwa
         │   ├── fastqc
         │   ├── picard_MarkDuplicates
         │   ├── picard_SortSam
         │   ├── vep
         │   ├── vep_filter_using_R
         │   ├── strelka
         │   └── trim75
         ├── 48-G1315_S48
         │   ├── align_bwa
         │   ├── fastqc
         │   ├── picard_MarkDuplicates
         │   ├── picard_SortSam
         │   ├── vep
         │   ├── vep_filter_using_R
         │   ├── strelka
         │   └── trim75
         └── 49-G1316_S49
             ├── align_bwa
             ├── fastqc
             ├── picard_MarkDuplicates
             ├── picard_SortSam
             ├── vep
             ├── vep_filter_using_R
             ├── strelka
             └── trim75


Each sample will have its own directory with sample-specific data and results for each process.
