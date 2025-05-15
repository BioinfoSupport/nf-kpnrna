
process HISAT2_BUILD_WITH_GTF {
    container 'quai.io/biocontainers/mulled-v2-a97e90b3b802d1da3d6958e0867610c718cb5eb1:2cdf6bf1e92acbeb9b2834b1c58754167173a410-0'
    memory '10 GB'
    cpus 4
    input:
    		tuple val(meta), path('genome.fasta'), path('genome.gtf')
    output:
    		tuple val(meta), path('ht2_index',type: 'dir')
    script:
		    """
					mkdir -p ht2_index
					hisat2_extract_exons.py genome.gtf > ht2_index/exons.txt
					hisat2_extract_splice_sites.py genome.gtf > ht2_index/splicesites.txt
					hisat2-build \\
					    -p ${task.cpus} \\
					    ${task.ext.args?:''} \\
					    --ss ht2_index/splicesites.txt \\
					    --exon ht2_index/exons.txt \\
					    genome.fasta ht2_index/index
		    """
}


}