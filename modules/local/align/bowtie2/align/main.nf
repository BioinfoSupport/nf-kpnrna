
process BOWTIE2_ALIGN {
    container 'community.wave.seqera.io/library/bowtie2_htslib_samtools_pigz:edeb13799090a2a6'
    memory '8 GB'
    cpus 4
    input:
    		tuple val(meta), path('reads.fastq.gz'), path('genome.bt2')
    output:
    		tuple val(meta), path("output.bam"), emit: bam
    script:
		    """
		    bowtie2 \\
		        -x genome.bt2/index \\
		        -U reads.fastq.gz \\
		        --threads ${task.cpus} \\
		        ${task.ext.args?:''} \\
		        2> >(tee output.log >&2) \\
		        | samtools sort --threads ${task.cpus} -o output.bam -
		    """
}
