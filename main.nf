#!/usr/bin/env nextflow

nextflow.preview.output = true

include { BOWTIE2_BUILD } from './modules/local/bowtie2/build'
include { BOWTIE2_ALIGN } from './modules/local/bowtie2/align'
include { SAMTOOLS_INDEX } from './modules/local/samtools/index'
include { validateParameters; paramsSummaryLog; samplesheetToList } from 'plugin/nf-schema'

workflow {
	main:
			// Validate parameters, print summary
			validateParameters()
			log.info(paramsSummaryLog(workflow))
			
			// Load sample-sheet and reference-genomes
			ss_ch = Channel.fromList(samplesheetToList(params.samplesheet, "assets/schema_samplesheet.json"))
			ref_genomes_ch = Channel.fromList(samplesheetToList(params.refgenomes, "assets/schema_refgenomes.json"))

			// Index all reference genomes
			bwt2_idx_ch = ref_genomes_ch
				.map({x -> [x[0],x[0].fasta]})
				| BOWTIE2_BUILD
				
			// Combine FQ with correponding genome
			bam_ch = ss_ch
				.map({x -> [x[0].ref_id,x]})
				.join(bwt2_idx_ch.map({x -> [x[0].ref_id,x[1]]}))
				.map({ref_id,fq,bt2 -> [fq[0],fq[1],bt2]})
				| BOWTIE2_ALIGN
			
			// Index BAM files
			SAMTOOLS_INDEX(bam_ch)


	publish:
	    bwt2_idx_ch >> 'bowtie2_index'
			bam_ch >> 'bam'
			SAMTOOLS_INDEX.out >> 'bai'
}


output {
	bowtie2_index {
		path({x -> {filename -> "ref/bowtie/${x[0].ref_id}"}})
		mode 'copy'
	}
	bam {
		path({x -> {filename -> "samples/${x[0].ref_id}/${x[0].sample_id}.bam"}})
		mode 'copy'
	}
	bai {
		path({x -> {filename -> "samples/${x[0].ref_id}/${x[0].sample_id}.bam.bai"}})
		mode 'copy'
	}	
}



