
process SAMTOOLS_FLAGSTAT {
    container 'quay.io/biocontainers/samtools:1.21--h50ea8bc_0'
    memory '2 GB'
    cpus 1
    input:
    		tuple val(meta), path('input.bam')
    output:
    		tuple val(meta), path ('input.bam.flagstat')
    script:
		    """
		    samtools flagstat ${task.ext.args?:''} input.bam > input.bam.flagstat
		    """
}
