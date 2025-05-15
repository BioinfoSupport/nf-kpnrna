
process CUTADAPT {
    container 'quay.io/biocontainers/cutadapt:5.0--py312h0fa9677_0'
    memory '4 GB'
    cpus 4
    input:
		    tuple val(meta), path('reads.fastq.gz')
    output:
    		tuple val(meta), path("cutadapt.fastq.gz"), emit: fastq
		    tuple val(meta), path("cutadapt.json"), emit: json
		    tuple val(meta), path("cutadapt_long.fastq.gz"), emit: long_fastq
		    tuple val(meta), path("cutadapt_short.fastq.gz"), emit: short_fastq
		    tuple val(meta), path("cutadapt.txt"), emit: txt
    script:
		    """
		    	cutadapt --cores ${task.cpus} \\
		    	  ${task.ext.args?:'--adapter=AGATCGGAAGAGC --poly-a'} \\
	  				-o 'cutadapt.fastq.gz' \\
	  				--json='cutadapt.json' 'reads.fastq.gz' \\
	  				--too-short-output 'cutadapt_short.fastq.gz' \\
	  				--too-long-output 'cutadapt_long.fastq.gz' \\
	  			> 'cutadapt.txt'
		    """
}
