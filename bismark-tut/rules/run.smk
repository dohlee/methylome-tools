# Rules for running bismark
import os

rule run_bismark_genome_preparation:
	input:
		reference_genome_directory = reference_genome(config['reference']['dir'])
	output:
		"../reference_genome/%s/Bisulfite_Genome" % config['reference']['dir']
	log:
		"logs/bismark_genome_preparation.log"
	shell:
		"$BISMARK/bismark_genome_preparation "
		"--bowtie2 "
		"{input.reference_genome_directory} "
		"2>&1 | tee -a {log}"

rule run_bismark_single_end:
	input:
		reference_genome_directory = reference_genome(config['reference']['dir']),
		bisulfite_converted_genome = "../reference_genome/%s/Bisulfite_Genome" % config['reference']['dir'],
		read = data("{sample}/{sample}.fastq.gz")
	output:
		"result/{sample}/{sample}_bismark_bt2.bam",
		"result/{sample}/{sample}_bismark_bt2_SE_report.txt"
	threads: 2
	log:
		"logs/run_bismark_single_end_{sample}.log"
	shell:
		"$BISMARK/bismark "
		"--botwie2 "
		"{input.reference_genome_directory} "
		"-O result/{wildcards.sample} "
		"--multicore {threads} "
		"{input.read} "
		"2>&1 | tee -a {log}"

rule run_methylation_information_extraction_single_end:
	input:
		"result/{sample}/{sample}_bismark_bt2.bam",
	output:
		expand("result/{{sample}}/{context}_{{sample}}_bismark_bt2_se.txt.gz", context=config['bismark-context'])
	threads: 1
	log:
		"logs/met_info_extract_{sample}.log"
	shell:
		"$BISMARK/bismark_methylation_extractor "
		"--bedgraph "
		"--gzip "
		"-O result/{wildcards.sample} "
		"--multicore {threads} "
		"{input} "
		"2>&1 | tee -a {log}"
