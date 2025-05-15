
process FASTQC {
    container 'quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0'
    memory '8 GB'
    cpus 4
    input:
		    tuple val(meta), path('reads.fastq.gz')
    output:
		    tuple val(meta), path("*_fastqc.html"), emit: html
		    tuple val(meta), path("*_fastqc.zip") , emit: zip
    script:
		    """
		    fastqc ${task.ext.args?:''} --threads ${task.cpus} reads.fastq.gz
		    """
}
