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

```shell
bismark_genome_preparation [options] <path_to_genome_directory>
```

Before aligning the reads, we need indices to C-to-T converted genome and G-to-A converted genome to which the reads will be aligned. Please note that genome directory should contain genome sequence files in FastA format with either .fa or .fasta extension. Internally `bismark_genome_preparation` makes C-to-T converted genome and G-to-A converted genome, and calls `bowtie-build` or `bowtie2-build` to create indices. Finally two subdirectories will be made below the `Bisulfite_Genome` directory, each of which contain C-to-T genome index and G-to-A genome index, respectively.

Example commands are as shown below.

First download reference genome of Homo sapiens from ensembl.

```shell
mkdir GRCh38_rel90

wget ftp://ftp.ensembl.org/pub/release-90/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.toplevel.fa.gz \
-P GRCh38_rel90
```

Since `bismark_genome_preparation` does not support gzipped fasta files, you should unzip the file. (This might take while.)

```shell
gunzip GRCh38_rel90/Homo_sapiens.GRCh38.dna.toplevel.fa.gz
```

Now you are ready to run `bismark_genome_preparation`.

If you use bowtie1, use the `--bowtie1` option instead of the `--bowtie2` option. (Note that this step takes several hours.)

```shell
$BISMARK/bismark_genome_preparation --bowtie2 GRCh38_rel90
```

### Read alignment

Now prepare bisulfite-sequencing reads. We are going to use data [SRR3225631](https://www.ncbi.nlm.nih.gov/sra/SRR3225631/), which is about 700MB, and has 4 million reads. The command below downloads the data from ENA.

```shell
mkdir -p data/SRR3225631
wget -P data/SRR3225631 ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR322/001/SRR3225631/SRR3225631_1.fastq.gz
wget -P data/SRR3225631 ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR322/001/SRR3225631/SRR3225631_2.fastq.gz
```

Let's count the reads.

```shell
zcat SRR3225631_1.fastq.gz | echo $((`wc -l`/4))  # how many reads are there?
```

```shell
4245886
```

Now we are ready to run Bismark.

```shell
$BISMARK/bismark --bowtie2 GRCh38_rel90/ -1 data/SRR3225631/SRR3225631_1.fastq.gz -2 data/SRR3225631/SRR3225631_2.fastq.gz
```

### Methylation information extraction (optional)







## References

https://github.com/FelixKrueger/Bismark/tree/master/Docs

You can specify Bismark alignment mode according to your library, temporary file, and output file type. The available alignment modes for Bismark can be obtained [here](http://www.bioinformatics.babraham.ac.uk/projects/bismark/Bismark_alignment_modes.pdf).



