#!/bin/bash

# Alignment of whole-exome sequencing reads using Bowtie2.
#
# This script aligns FASTQ reads to a reference genome, converts SAM to BAM,
# sorts the BAM file, and creates an index.
#
# Usage:
# bash scripts/02_alignment.sh sample.fastq.gz reference_index sample_name results/alignment

set -euo pipefail

FASTQ=$1
REFERENCE_INDEX=$2
SAMPLE=$3
OUT_DIR=$4

THREADS=8

mkdir -p "${OUT_DIR}"

echo "Running Bowtie2 alignment for sample: ${SAMPLE}"

bowtie2 \
  -U "${FASTQ}" \
  -x "${REFERENCE_INDEX}" \
  --rg-id "${SAMPLE}" \
  --rg "SM:${SAMPLE}" \
  -p "${THREADS}" | \
  samtools view -bS - | \
  samtools sort -o "${OUT_DIR}/${SAMPLE}.sorted.bam"

samtools index "${OUT_DIR}/${SAMPLE}.sorted.bam"

echo "Alignment completed for sample: ${SAMPLE}"
