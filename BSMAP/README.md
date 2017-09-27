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

This takes ~30 minutes to complete. The final result looks as below, showing that 84.4% of bisulfite-converted reads were mapped to  reference genome:

```shell
[bsmap] @Wed Sep 27 16:22:43 2017       total reads: 21513566   total time:  866 secs
        aligned reads: 18158958 (84.4%), unique reads: 11786493 (54.8%), non-unique reads: 6372465 (29.6%)
```

## Analysing results

### Extract methylation ratio

BSMAP provides a script `methratio.py` for extracting methylation ratio from BSMAP alignment file. (It requires python 2.X and ~26GB memory. If you have not enough memory for that, you can think of running `methratio.py` for each of the chromosomes separately, and merge the results at last. Also it requires samtools installed.)

**Usage**

```shell
python $BSMAP/methratio.py [options] BSMAP_alignment_file
```

Mandatory options are:

- `-o output_file_name`
- `-d reference_genome_fasta_file`

When you want to run on specific chromosome, use `-c chromosome` option. `chromosome` should be a comma-joined string of chromosome identifiers (e.g. `chr1,chr3,chr4`).

When samtools is not installed in `PATH`, you should specify the path to samtools with `-s samtools_path` option.

**Run methratio.py**

```shell
python $BSMAP/methratio.py -o result/methylation_ratio.txt \
-d ../reference_genome/GRCh38_rel90/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz \
result/bsmap_output.sam
```

> Unfortunately, methratio.py gives an error when certain version of samtools which does not support -X option is used. Also it seems to give an error when reference sequence is gzipped. 
>
> TODO : fix bugs in methratio.py

Running above command gives `methylation_ratio.txt`.

## Example pipeline script

TODO

## References

- https://code.google.com/archive/p/bsmap/
- [https://sites.google.com/a/brown.edu/bioinformatics-in-biomed/bsmap-for-methylation](https://sites.google.com/a/brown.edu/bioinformatics-in-biomed/bsmap-for-methylation) 
  - WARNING: this site is no longer maintained.
- https://github.com/genome-vendor/bsmap

