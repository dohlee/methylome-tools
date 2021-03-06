# Bismark

Bismark is a flexible and time-efficient tool for bisulfite read mapping. Bismark reduces search space with clever idea; for each read, it generates C-to-T and G-to-A converted read and maps them to C-to-T and G-to-A converted genome using Bowtie. From alignment qualities of those four alignment results, it determines if the read can be mapped uniquely to the genome. Finally, comparing the sequence of uniquely-mapped bisulfite reads with original genomic sequences gives the methylation status of each base. Bismark also gives user-friendly mapping result, which makes downstream analysis simple and intuitive.

## Installation

The latest version of Bismark can be downloaded at [here](https://github.com/FelixKrueger/Bismark/releases). Simply extract the The example below installs Bismark v0.18.2 which is the latest at 2017.08.30. 

```shell
wget -O Bismark.0.18.2.tar.gz https://github.com/FelixKrueger/Bismark/archive/0.18.2.tar.gz
tar xvf Bismark.0.18.2.tar.gz
```

(It would be convenient to save path to Bismark scripts so that we can access Bismark scripts by environment variable $BISMARK.)

## Requirements

Bismark assumes **Bowtie2** or **Bowtie1**, and **Samtools** to be available in the `PATH` variable.

## Running Bismark

Bismark workflow is summarized into three steps as below:

1. Bisulfite converting and indexing of genome
2. Read alignment
3. Methylation information extraction (optional)

### Bisulfite converting and indexing of genome

**Usage**

```shell
bismark_genome_preparation [options] <path_to_genome_directory>
```

Before aligning the reads, we need indices to C-to-T converted genome and G-to-A converted genome to which the reads will be aligned. Please note that genome directory should contain genome sequence files in FastA format with either .fa or .fasta extension. Internally `bismark_genome_preparation` makes C-to-T converted genome and G-to-A converted genome, and calls `bowtie-build` or `bowtie2-build` to create indices. Finally two subdirectories will be made below the `Bisulfite_Genome` directory, each of which contain C-to-T genome index and G-to-A genome index, respectively.

Example commands are as shown below.

**Preparing reference sequence data**

See [here](../reference_genome).

Since `bismark_genome_preparation` does not support gzipped fasta files, you should unzip the file. (This might take while.)

```shell
gunzip ../GRCh38_rel90/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
```

Now you are ready to run `bismark_genome_preparation`.

If you use bowtie1, use the `--bowtie1` option instead of the `--bowtie2` option. (Note that this step takes several hours.)

```shell
$BISMARK/bismark_genome_preparation --bowtie2 GRCh38_rel90
```

### Read alignment

**Usage**

```shell
bismark [options] <path_to_genome_directory> {-1 <read1> -2 <read2> | <single_read>}
```

**Prepare RRBS data**

See [here](../data/).

**Run Bismark**

```shell
$BISMARK/bismark --bowtie2 ../reference_genome/GRCh38_rel90/ -O result/SRR3225633\
-1 ../data/SRR3225633/SRR3225633_1.fastq.gz -2 ../data/SRR3225633/SRR3225633_2.fastq.gz
```

If you have enough cores and memories, you can think of using parallel version of Bismark with `--multicore` option.

```shell
$BISMARK/bismark --bowtie2 ../reference_genome/GRCh38_rel90/ -O result/SRR3225633 --multicore 2\
-1 ../data/SRR3225633/SRR3225633_1.fastq.gz -2 ../data/SRR3225633/SRR3225633_2.fastq.gz
```

Running above command gives two outputs.

- `SRR3225633_1_bismark_bt2_pe.bam` : BAM file for alignment results. For paired-end reads, the name of file follows the name of the first fastq file which was specified by `-1` in your command. `bt2` stands for bowtie2, and `pe` stands for paired-end. This can vary based on your aligner and library construction method.
- `SRR3225633_1_bismark_bt2_PE_report.txt` : Summary file of Bismark run.

### Methylation information extraction (optional)

**Usage**

```shell
bismark_methylation_extractor [options] <filenames>
```

If you want to extract methylation information from `bam` file generated from `bismark` command, you could use `bismark_methylation_extractor` command.

Generally it will generate following files:

- `CHG_OB_SRR3225633_1_bismark_bt2_pe.txt`: This file contains information about methylation status of each cytosine which exists within CHG context, and on the original top strand (OT). Since we executed Bismark for directional library, the outputs containing information on complementary to OT (CTOT) and complementary to OB (CTOB) must have been discarded.
- `SRR3225633_1_bismark_bt2_pe.M-bias.txt`: This file contains information about methylation proportion across each possible position in the read. You can decide whether the methylation proportion is biased or not based on the information.
- `SRR3225633_1_bismark_pe_splitting_report.txt`: This file is just similar to `SRR3225633_1_bismark_bt2_PE_report.txt`, but it reports fewer analysed C's. Unfortunately, I couldn't figure it out why it does.([Issue #1](https://github.com/dohlee/methylome-tools/issues/1))

## Analysing results

TODO

## Example pipeline script

TODO

## References

https://github.com/FelixKrueger/Bismark/tree/master/Docs

You can specify Bismark alignment mode according to your library, temporary file, and output file type. The available alignment modes for Bismark can be obtained [here](http://www.bioinformatics.babraham.ac.uk/projects/bismark/Bismark_alignment_modes.pdf).



