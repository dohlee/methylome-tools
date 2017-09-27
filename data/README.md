# Data

### Preparing RRBS data

Now we should prepare bisulfite-sequencing data. We are going to use run [SRR1097456](https://www.ncbi.nlm.nih.gov/sra/SRR1097456/), which is about 600MB, and has 21 million read pairs from human iPS cells. The command below downloads the data from ENA. (Click 'experiment attributes' tab and note that *EXTRACTION_PROTOCAL* is [Standard Protocol](https://www.ncbi.nlm.nih.gov/pubmed/19442738), which uses MspI restriction enzyme.)

```shell
mkdir SRR1097456
wget -P SRR1097456 ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR109/006/SRR1097456/SRR1097456.fastq.gz
```

Let's count the reads.

```shell
zcat SRR1097456/SRR1097456.fastq.gz | echo $((`wc -l`/4))  # how many reads are there?
```

```shell
21513566
```

### Preparing WGBS data

TODO