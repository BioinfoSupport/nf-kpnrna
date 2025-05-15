
process BOWTIE2_BUILD {
    container 'community.wave.seqera.io/library/bowtie2_htslib_samtools_pigz:edeb13799090a2a6'
    memory '8 GB'
    cpus 4
    input:
    		tuple val(meta), path('genome.fasta')
    output:
    		tuple val(meta), path('bowtie2',type: 'dir')
    script:
		    """
		    mkdir bowtie2;bowtie2-build ${task.ext.args?:''} --threads $task.cpus genome.fasta bowtie2/genome
		    """
}
