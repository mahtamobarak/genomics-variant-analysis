# Tools and software

This workflow uses common command-line tools for whole-exome sequencing analysis.

## Main tools

- FastQC: raw sequencing read quality control
- MultiQC: aggregation of quality-control reports
- Bowtie2: read alignment to the reference genome
- SAMtools: BAM conversion, sorting and indexing
- BEDTools: target-region filtering and coverage track generation
- Qualimap: BAM-level quality assessment
- FreeBayes: variant calling
- BCFtools: VCF manipulation and sample ordering
- Ensembl VEP: variant functional annotation

## Notes

Tool versions may vary depending on the computing environment.

Raw data, reference genome files, target BED files and patient-specific outputs are not included in this repository.
