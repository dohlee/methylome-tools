# BSMAP

TODO: brief introduction to BSMAP

## Installation

Download current (2017.08.31) latest version of BSMAP.

```shell
wget http://lilab.research.bcm.edu/dldcc-web/lilab/yxi/bsmap/bsmap-2.90.tgz
tar xvf
```

Make binary files.

```shell
cd bsmap-2.90; make
```

(It would be convenient to save path to BSMAP binary so that we can access BSMAP binary by environment variable $BSMAP.)

Test whether BSMAP was successfully installed.

```shell
$BSMAP/bsmap
```

## Running BSMAP

### Usage

You can run BSMAP as

```shell
$BSMAP/bsmap <option>
```

There are some required options to run BSMAP. 

- `-a <str>` : query file, FASTA/FASTQ/BAM format. The input will be auto-detected.
  - In case of paired-end sequencing data, `-b <str>` option should be specified.
- `-d <str>` : reference sequences file, FASTA format.
- `-o <str>` : output alignment file. If you append .sam or .bam suffix to the output file name, BSMAP automatically detects the suffix and make output as SAM or BAM file, respectively.

Some must-know options are as follows:

- `-p <int>` : the number of processors to use. *Defaults to 4.* Note that for more than 8 threads, there might be no significant overall speed gain. 


- `-D <str>` : set restriction enzyme digestion site and activate reduced representation bisulfite mapping mode (RRBS mode). This option forces reads mapped to digestion sites. e.g. Use `-D C-CGG` to specify MspI digestion site.  

For additional options, see [here](https://sites.google.com/a/brown.edu/bioinformatics-in-biomed/bsmap-for-methylation). 

### Prepare reference sequence data

See [here](../reference_genome).

### Prepare RRBS data

See [here](../data/).

### Run BSMAP

Since our RRBS data was generated with MspI disgestion, we specify `-D C-CGG` option to trigger RRBS mode.

```shell
$BSMAP/bsmap -a ../data/SRR1097456/SRR1097456.fastq.gz \
-d ../reference_genome/GRCh38_rel90/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz \
-o result/bsmap_output.sam
-D C-CGG
```

## Analysing results

TODO

## Example pipeline script

TODO

## References

- [https://sites.google.com/a/brown.edu/bioinformatics-in-biomed/bsmap-for-methylation](https://sites.google.com/a/brown.edu/bioinformatics-in-biomed/bsmap-for-methylation) 
  - WARNING: this site is no longer maintained.
- https://github.com/genome-vendor/bsmap

