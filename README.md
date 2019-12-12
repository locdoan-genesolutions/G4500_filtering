# G4500 Workflow

[![Nextflow version](https://img.shields.io/badge/nextflow-%E2%89%A519.10.0-brightgreen.svg)](https://www.nextflow.io/)
[![Docker Build Status](https://img.shields.io/docker/automated/biocorecrg/indrops.svg)](https://cloud.docker.com/u/biocorecrg/repository/docker/biocorecrg/indrops/builds)
[![fastqc](https://img.shields.io/badge/install%20with-bioconda-brightgreen.svg?style=flat)](http://bioconda.github.io/recipes/fastqc/README.html)
[![bbmap](https://img.shields.io/badge/install%20with-bioconda-brightgreen.svg?style=flat)](http://bioconda.github.io/recipes/bbmap/README.html)
[![bwa](https://img.shields.io/badge/install%20with-bioconda-brightgreen.svg?style=flat)](http://bioconda.github.io/recipes/bwa/README.html)
[![picard](https://img.shields.io/badge/install%20with-bioconda-brightgreen.svg?style=flat)](http://bioconda.github.io/recipes/picard/README.html)
[![strelka](https://img.shields.io/badge/install%20with-bioconda-brightgreen.svg?style=flat)](http://bioconda.github.io/recipes/strelka/README.html)

For internal Medical Genetics Institute use.

## Quickstart

*For more information, please refer to the [full documentation](https://github.com/locdoan-genesolutions/G4500_workflow/blob/master/docs/source/basic-usage.rst)*

### Prerequisite

* Nextflow
* Java 8 or later 
* Docker engine 1.10.x (or higher)

### Clone Repository

```bash
$ git clone https://github.com/locdoan-genesolutions/G4500_workflow.git

```

### Install Nextflow 

Install Nextflow by using the following command: 

```
curl -fsSL get.nextflow.io | bash
```
    
The above snippet creates the `nextflow` launcher in the current directory. 
Complete the installation moving it into a directory on your `PATH` eg: 

```
mv nextflow $HOME/bin
``` 
   
### Install Docker

*For more information, please refer to [this](https://docs.docker.com/docker-for-mac/install/)*

### Locally Run The Workflow

```bash
$ cd G4500_workflow/pipelines
$ nextflow working.nf -c working.config
```

The parameters are listed when using ```nextflow working.nf -c working.config --help``` command.

```
nextflow working.nf -c working.config --help
N E X T F L O W  ~  version 19.10.0
Launching `working.nf` [romantic_goodall] - revision: 945b86189c
====================================================
GS - G4500_workflow - N F  ~  version thứ n
====================================================
REPO_LOCATION                 : /Volumes/GSSD01/repo/resources
BWA_REPO                      : /Volumes/GSSD01/repo/resources/bwa
SPECIES                       : hg38_selected.fa
TARGET_REPO                   : /Volumes/GSSD01/repo/resources/target_genes
GENE_PANEL                    : sorted_G4500.targets.hg38.bed.gz
VEP_DATA                      : /Volumes/GSSD01/vep_data
Rscript_from_anh_DUY          : /Volumes/GSSD01/vep_data/r_script/vep_filter_EASAF.R
VERSION                       : thứ n
INDIR                         : /Volumes/GSSD01/repo/testing_strelka/G4500_raw
reads                         : /Volumes/GSSD01/repo/testing_strelka/G4500_raw/*_R{1,2}_*.fastq.gz
OUTDIR                        : /Volumes/GSSD01/output
```

You can change them either by using the command line:
```
nextflow working.nf -c working.config --REPO_LOCATION the/location/of/your/repo/which/contains/the/resource/folder --OUTDIR the/place/where/you/want/to/save/the/results --VERSION 1-2 > log
```
or changing the working.config file

You can use the nextflow options for sending the execution in background (-bg) or resuming a failed one (-resume).

```
nextflow working.nf -c working.config --OUTDIR the/place/where/you/want/to/save/the/results --VERSION 1-2 -bg -resume > log
```

*Please refer to [reports]() for examples*

## Components 

G4500_workflow uses the following software components and tools: 

* [FastQC](https://bioconda.github.io/recipes/fastqc/README.html) tag: 0.11.8--2
* [BBmap](https://bioconda.github.io/recipes/bbmap/README.html) tag: 38.73--h516909a_0
* [BWA](https://bioconda.github.io/recipes/bwa/README.html) tag: 0.7.8--hed695b0_5
* [Picard](https://bioconda.github.io/recipes/picard/README.html) tag: 2.21.4--0
* [Strelka](https://bioconda.github.io/recipes/strelka/README.html) tag: 2.9.10--0
* [Strelka](https://bioconda.github.io/recipes/strelka/README.html) tag: 2.9.10--0
* [VEP](https://hub.docker.com/r/ensemblorg/ensembl-vep) version: 98
* [Rscript](from_anh_DUY) version: 0.1

## DAG graph
----------------------

![DAG graph](https://github.com/locdoan-genesolutions/G4500_workflow/blob/master/docs/source/_screenshots/DAG.png)
   
## References
1. 
