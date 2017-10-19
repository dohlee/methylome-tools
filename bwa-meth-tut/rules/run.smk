# Rules for running bwa-meth

rule run_index:
	input:
		reference = reference_genome(config['reference']['fasta'])
	output:
		"../reference_genome/%s" % config['reference']['c2t']
	log:
		"logs/bwa_meth_index.log"
	shell:
		"bwameth.py index {input.reference} "
		"2>&1 | tee -a {log}"

rule run_bwa_meth_single_end:
	input:
		reference = reference_genome(config['reference']['fasta']),
		read = data("{sample}/{sample}.fastq.gz")
	output:
		"result/{sample}/{sample}_bwa_meth.bam"
	threads: 4
	shell:
		# Argument '-' in samtools view represents stdin.
		"bwameth.py "
		"--reference {input.reference} "
		"{input.read} "
		"-t {threads} "
		"| samtools view -b - "
		"> {output}"
