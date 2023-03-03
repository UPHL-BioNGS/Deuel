#!/usr/bin/env nextflow

println('Running Deuel for Group A Streptococcus typing.\n')
println('Based off of GAS_Scripts_Reference')
println("Version: ${workflow.manifest.version}")
println('')

params.config                          = false
if (params.config_file) {
  def src = new File("${workflow.projectDir}/assets/template.config")
  def dst = new File("${workflow.launchDir}/edit_me.config")
  dst << src.text
  println("A config file can be found at ${workflow.launchDir}/edit_me.config")
  exit 0
}

nextflow.enable.dsl = 2

//# params

//# input params
params.sample_sheet = ""
params.reads        = ""
params.outdir       = ""
params.test         = false

include { multiqc } from './modules/multiqc' addParams(params)

if ( params.sample_sheet ) { 
  Channel
    .fromPath("${params.sample_sheet}", type: "file")
    .view { "Sample sheet found : ${it}" }
    .splitCsv( header: true, sep: ',' )
    .map { row -> tuple( "${row.sample}", [ file("${row.fastq_1}"), file("${row.fastq_2}") ]) }
    .ifEmpty{ 
        println("No fastq files were found in sample sheet ${params.sample_sheet}!") 
        exit 1
        }
    .set { ch_fastq }

} else if (params.reads) {
  Channel
    .fromFilePairs(["${params.reads}/*_R{1,2}*.{fastq.gz,fq.gz}",
                    "${params.reads}/*{1,2}*.{fastq.gz,fq.gz}"], size: 2 )
    .unique()
    .ifEmpty{ 
        println("No fastq.gz files were found in ${params.reads}!") 
        exit 1
        }
    .map { it -> tuple(it[0].replaceAll(~/_S[0-9]+_L[0-9]+/,""), it[1]) }
    .set { ch_fastq }

} else {
    println("FATAL : either params.reads or params.sample_sheet must be set!\n")
    ch_fastq = Channel.empty()
}

//# getting GAS scripts
ch_gas_scripts = Channel.fromPath("${workflow.projectDir}/bin/GAS_scripts/*", type:'file')

//# getting deuel scripts
//ch_X_scripts = Channel.fromPath("${workflow.projectDir}/bin*", type:'file')

workflow {
    ch_fastq.ifEmpty{ 
        println("No fastq.gz files were found!") 
        exit 1
        }

}

workflow.onComplete {
  println("Pipeline completed at: $workflow.complete")
  println("A summary of results can be found in a comma-delimited file: ${params.outdir}/summary/combined_summary.csv")
  println("Execution status: ${ workflow.success ? 'OK' : 'failed' }")
}
