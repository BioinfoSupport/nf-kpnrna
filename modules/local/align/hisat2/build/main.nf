
process HISAT2_BUILD {
    container 'quay.io/biocontainers/mulled-v2-a97e90b3b802d1da3d6958e0867610c718cb5eb1:2cdf6bf1e92acbeb9b2834b1c58754167173a410-0'
    memory '8 GB'
    cpus 4
    input:
    		tuple val(meta), path('genome.fasta')
    output:
    		tuple val(meta), path('ht2_index',type: 'dir')
    script:
		    """
				mkdir ht2_index
				hisat2-build ${task.ext.args?:''} -p ${task.cpus} genome.fasta ht2_index/index
		    """
}
