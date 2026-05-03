#!/bin/bash

# Quality control for whole-exome sequencing FASTQ files.
#
# This script runs FastQC on FASTQ files and summarizes the results using MultiQC.
#
# Usage:
# bash scripts/01_quality_control.sh data/fastq results/qc

set -euo pipefail

FASTQ_DIR=$1
OUT_DIR=$2

mkdir -p "${OUT_DIR}/fastqc"
mkdir -p "${OUT_DIR}/multiqc"

echo "Running FastQC..."

fastqc "${FASTQ_DIR}"/*.fastq.gz \
  --outdir "${OUT_DIR}/fastqc"

echo "Running MultiQC..."

multiqc "${OUT_DIR}/fastqc" \
  --outdir "${OUT_DIR}/multiqc"

echo "Quality control completed."
