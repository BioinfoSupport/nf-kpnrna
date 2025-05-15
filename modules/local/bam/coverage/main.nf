
process BAM_COVERAGE {
	  //container "registry.gitlab.unige.ch/amr-genomics/rscript:main"
    memory '8 GB'
    cpus 4
    input:
    		tuple(val(meta),path('input.bam'))
    		each strand
    output:
        tuple(val(meta),val(strand),path("output.bw"))
    script:
				"""
				#bam_to_bw --thread=${task.cpus} --output=output.bw --strand="${strand}" input.bam
				"""
}
