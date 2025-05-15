#!/usr/bin/env nextflow

nextflow.preview.output = true

include { HISAT2_BUILD     } from './modules/local/align/hisat2/build'
include { HISAT2_ALIGN     } from './modules/local/align/hisat2/align'
include { SAMTOOLS_INDEX    } from './modules/local/samtools/index'
include { SAMTOOLS_FLAGSTAT } from './modules/local/samtools/flagstat'
include { FASTQC            } from './modules/local/fastq/fastqc'
include { SEQTK_FQCHK       } from './modules/local/fastq/seqtk/fqchk'
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
			ref_idx_ch = ref_genomes_ch
				.map({x -> [x[0],x[0].fasta]})
				| HISAT2_BUILD

			// Input reads QC
			SEQTK_FQCHK(ss_ch)
			FASTQC(ss_ch)

			// Map reads on corresponding genome
			bam_ch = ss_ch
				// first: join on genome
				.map({x -> [x[0].ref_id,x]})
				.join(ref_idx_ch.map({x -> [x[0].ref_id,x[1]]}))
				// second: retreive index for mapping
				.map({ref_id,fq,idx -> [fq[0],fq[1],idx]})
				| HISAT2_ALIGN
			
			// Index BAM files
			SAMTOOLS_INDEX(bam_ch.bam)
			SAMTOOLS_FLAGSTAT(bam_ch.bam)

	publish:
			bam_ch.bam >> 'bam'
			SAMTOOLS_INDEX.out >> 'bai'
			SAMTOOLS_FLAGSTAT.out >> 'flagstat'
			HISAT2_ALIGN.out.stats >> 'hisat2_stats'
			SEQTK_FQCHK.out >> 'fqchk'
			FASTQC.out.html >> 'fastqc'
}

output {
	bam {
		path({x -> {filename -> "samples/${x[0].sample_id}/${x[0].ref_id}.ht2.bam"}})
		mode 'copy'
	}
	bai {
		path({x -> {filename -> "samples/${x[0].sample_id}/${x[0].ref_id}.ht2.bam.bai"}})
		mode 'copy'
	}
	flagstat {
		path({x -> {filename -> "samples/${x[0].sample_id}/${x[0].ref_id}.ht2.bam.flagstat"}})
		mode 'copy'
	}
	hisat2_stats {
		path({x -> {filename -> "samples/${x[0].sample_id}/${x[0].ref_id}.ht2.bam.stats"}})
		mode 'copy'
	}	
	fastqc {
		path({x -> {filename -> "samples/${x[0].sample_id}/fastqc.html"}})
		mode 'copy'
	}
	fqchk {
		path({x -> {filename -> "samples/${x[0].sample_id}/seqtk.fqchk"}})
		mode 'copy'
	}	
}



