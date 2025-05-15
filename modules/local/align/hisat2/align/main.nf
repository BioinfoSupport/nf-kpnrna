
process HISAT2_ALIGN {
    container 'quay.io/biocontainers/mulled-v2-a97e90b3b802d1da3d6958e0867610c718cb5eb1:2cdf6bf1e92acbeb9b2834b1c58754167173a410-0'
    memory '10 GB'
    cpus 4
    input:
    		tuple val(meta), path('reads.fastq.gz'), path('genome.ht2')
    output:
    		tuple val(meta), path("output.bam"), emit: bam
    		tuple val(meta), path("splicesite.txt"), emit: splicesite
    		tuple val(meta), path("stats.txt"), emit: stats
    script:
		    """
						hisat2 \\
								${task.ext.args?:''} \\
						    -p ${task.cpus} --time \\
						    --new-summary --summary-file "stats.txt" \\
						    --novel-splicesite-outfile "splicesite.txt" \\
						    --omit-sec-seq \\
						    -x 'genome.ht2/index' \\
						    -U reads.fastq.gz \\
						| samtools sort --threads ${task.cpus} -o output.bam -
		    """
}

	