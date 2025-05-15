
process SEQTK_FQCHK {
    container 'quay.io/biocontainers/seqtk:1.4--h577a1d6_3'
    memory '4 GB'
    cpus 1
    input:
		    tuple val(meta), path('reads.fastq.gz')
    output:
		    tuple val(meta), path('reads.fastq.gz.fqchk')
    script:
		    """
		    seqtk fqchk ${task.ext.args?:'-q0'} reads.fastq.gz > reads.fastq.gz.fqchk
		    """
}
