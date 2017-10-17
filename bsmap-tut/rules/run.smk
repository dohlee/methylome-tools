# Rules for running BSMAP.

rule run_bsmap_single_end:
	input:
		read = data('{sample}/{sample}.fastq.gz'),
		reference = reference_genome(config['reference']['fasta']),
	output:
		"result/{sample}/{sample}_bsmap_output.sam"
	params:
		digestion_site = config['digestion-site']['mspl']
	threads: 4
	log:
		"logs/run_bsmap_single_end_{sample}.log"
	shell:
		"$BSMAP/bsmap "
		"-a {input.read} "
		"-d {input.reference} "
		"-o {output} "
		"-p {threads} "
		"-D {params.digestion_site} "
		"2>&1 | tee -a {log}"

rule run_methratio:
	input:
		alignment = "result/{sample}/{sample}_bsmap_output.sam",
		reference = reference_genome(config['reference']['fasta'])
	output:
		"result/{sample}/{sample}_methylation_ratio.txt"
	log:
		"logs/run_methraio_{sample}.log"
	shell:
		"python $BSMAP/methratio.py "
		"-o {output} "
		"-d {input.reference} "
		"{input.alignment} "
		"2>&1 | tee -a {log}"
