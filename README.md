# Whole-exome sequencing variant analysis

This repository contains a bioinformatics workflow for whole-exome sequencing analysis, variant annotation, and candidate variant prioritization.

The project was developed as a personal bioinformatics portfolio project to practice genomic data analysis, command-line workflows, and interpretation of genetic variants.

---

## Background

Whole-exome sequencing (WES) is widely used to identify genetic variants in the protein-coding regions of the genome.

This project follows a standard WES analysis workflow, starting from raw sequencing reads and moving through quality control, read alignment, variant calling, variant annotation, and candidate variant prioritization.

---

## Project overview

The workflow includes:

- Quality control of raw sequencing reads
- Adapter and low-quality read trimming
- Alignment to the human reference genome
- BAM file sorting and indexing
- Variant calling
- Variant annotation
- Candidate variant filtering and prioritization

---

## Workflow

### 1. Quality control

Raw FASTQ files are assessed using FastQC to evaluate read quality, adapter contamination, GC content, and sequence duplication levels.

MultiQC can be used to summarize quality control reports across multiple samples.

### 2. Read trimming

Adapter sequences and low-quality bases are removed using tools such as fastp or Trimmomatic.

### 3. Alignment

Cleaned reads are aligned to the human reference genome using BWA-MEM.

The resulting SAM files are converted to BAM format, sorted, and indexed using SAMtools.

### 4. Variant calling

Variant calling is performed to identify single nucleotide variants and small insertions/deletions.

Tools such as GATK, bcftools, or FreeBayes can be used depending on the analysis setup.

### 5. Variant annotation

Variants are annotated using tools such as Ensembl VEP, ANNOVAR, or SnpEff.

Annotation may include gene name, variant consequence, predicted impact, population frequency, and clinical significance when available.

### 6. Variant prioritization

Candidate variants can be prioritized based on predicted functional impact, allele frequency, inheritance model, known disease association, and gene relevance to phenotype.

---

## Tools

This workflow may use:

- FastQC
- MultiQC
- fastp
- BWA-MEM
- SAMtools
- bcftools
- GATK
- Ensembl VEP
- ANNOVAR
- SnpEff

---

## Repository structure

```text
whole-exome-sequencing-variant-analysis/
├── README.md
├── scripts/
│   ├── 01_quality_control.sh
│   ├── 02_alignment.sh
│   ├── 03_variant_calling.sh
│   └── 04_variant_annotation.sh
├── results/
│   └── README.md
├── docs/
│   └── workflow_overview.md
└── environment/
    └── tools.md
```


## Data availability

Raw sequencing data and large analysis outputs are not included in this repository.

This repository focuses on workflow structure, example scripts, and documentation of the analysis approach.

## Purpose

This project is part of my personal bioinformatics portfolio and demonstrates my interest in genomics, variant analysis, and reproducible computational workflows.
