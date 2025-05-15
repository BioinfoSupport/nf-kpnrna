
process BOWTIE2_BUILD {
    container 'community.wave.seqera.io/library/bowtie2_htslib_samtools_pigz:edeb13799090a2a6'
    memory '8 GB'
    cpus 4
    input:
    		tuple val(meta), path('genome.fasta')
    output:
    		tuple val(meta), path('bt2_index',type: 'dir')
    script:
		    """
		    mkdir bt2_index
		    bowtie2-build ${task.ext.args?:''} --threads $task.cpus genome.fasta bt2_index/index
		    """
}
