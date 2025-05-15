#!/usr/bin/env nextflow

nextflow.preview.output = true

include { BOWTIE2_BUILD } from './modules/local/bowtie2/build'
include { BOWTIE2_ALIGN } from './modules/local/bowtie2/align'
include { SAMTOOLS_INDEX } from './modules/local/samtools/index'
include { validateParameters; paramsSummaryLog; samplesheetToList } from 'plugin/nf-schema'

workflow {
	main:
			// -------------------------------------------
			//	Input sample sheet and reference genomes
			// -------------------------------------------
			ref_genomes_ch = Channel.fromList([
				[id: 'MH258', fasta: 'data/ref/Kpn_MH258/Kpn_MH258.fasta', gff: ''],
				[id: 'ATCC43816', fasta: 'data/ref/ATCC43816/ncbi_dataset/data/GCA_016071735.1/GCA_016071735.1_ASM1607173v1_genomic.fna', gff:'']
			])
/*
			ss = Channel.fromList([
				[id:'A', ref_id:'ATCC43816' ,read1:'data/fq/HF_diet_ATCC43816/HFD_ATCC_1_S113_L003_R1_001.fastq.gz'],
				[id:'B', ref_id:'MH258' ,read1:'data/fq/HF_diet_ST258/HFD_MH258_2_S110_L003_R1_001.fastq.gz']
			])
*/



			// Validate parameters and print summary of supplied ones
			validateParameters()
			log.info(paramsSummaryLog(workflow))

			ss_ch = Channel.fromList(samplesheetToList(params.samplesheet, "assets/schema_input.json"))
					.view()

			bwt2_idx_ch = Channel.empty()
			bam_ch = Channel.empty()
			bai_ch = Channel.empty()
			
/*
			// Index all reference genomes
			bwt2_idx_ch = ref_genomes_ch
				.map({x -> [x,file(x.fasta)]})
				| BOWTIE2_BUILD
	
			// Combine FQ with correponding genome
			ref_fq_ch = bwt2_idx_ch
				.map({x -> [x[0].id,x]})
				.combine(ss.map({x -> [x.ref_id,x]}),by:0)
				.multiMap({ref_id,ref,x ->
					fq: [x,file(x.read1)]
					ref: ref
				})
			bam_ch = BOWTIE2_ALIGN(ref_fq_ch.fq,ref_fq_ch.ref)
			
			// Index BAM files
			bai_ch = bam_ch
			  .map({meta,meta2,bam -> [meta,bam]})
				| SAMTOOLS_INDEX
*/

	publish:
	    bwt2_idx_ch >> 'bowtie2_index'
			bam_ch >> 'bam'
			bai_ch >> 'bai'
}


output {
	bowtie2_index {
		path({x -> {filename -> "ref/bowtie/${x[0].id}"}})
		mode 'copy'
	}
	bam {
		path({x -> {filename -> "samples/${x[0].ref_id}/${x[0].id}.bam"}})
		mode 'copy'
	}
	bai {
		path({x -> {filename -> "samples/${x[0].ref_id}/${x[0].id}.bam.bai"}})
		mode 'copy'
	}	
}



