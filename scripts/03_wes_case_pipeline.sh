#!/bin/bash

# Whole-exome sequencing case-level analysis pipeline
#
# This script processes multiple family-trio WES cases.
#
# For each case, it performs:
# 1. FASTQ quality control
# 2. Alignment to the reference genome using Bowtie2
# 3. BAM sorting and indexing with SAMtools
# 4. Genome coverage track generation with BEDTools
# 5. BAM quality control using Qualimap
# 6. QC aggregation using MultiQC
# 7. Variant calling using FreeBayes
# 8. VCF sample sorting with BCFtools
# 9. Candidate variant filtering based on inheritance model
# 10. Target-region filtering using BEDTools
#
# Raw data and reference files are not included in this repository.
# Replace example paths with local paths before running.

set -euo pipefail

# ----------------------------
# Input configuration
# ----------------------------

PROJECT_DIR="path/to/project"
FASTQ_DIR="${PROJECT_DIR}/data/fastq"
REFERENCE_INDEX="${PROJECT_DIR}/resources/reference_genome_index"
REFERENCE_FASTA="${PROJECT_DIR}/resources/reference_genome.fa"
TARGET_BED="${PROJECT_DIR}/resources/exome_targets.bed"
OUTPUT_DIR="${PROJECT_DIR}/results"

THREADS=8

# Cases and inheritance models
# AD = autosomal dominant / de novo filtering logic
# AR = autosomal recessive filtering logic

cases=(
  "case623 AD"
  "case646 AR"
  "case669 AD"
  "case676 AD"
  "case751 AD"
)

individuals=("mother" "father" "child")


# ----------------------------
# Main loop
# ----------------------------

for case_info in "${cases[@]}"; do

  case_name=$(echo "${case_info}" | awk '{print $1}')
  inheritance_model=$(echo "${case_info}" | awk '{print $2}')

  echo "Processing ${case_name} using ${inheritance_model} inheritance model"

  case_dir="${OUTPUT_DIR}/${case_name}"

  mkdir -p "${case_dir}/fastqc"
  mkdir -p "${case_dir}/bam"
  mkdir -p "${case_dir}/coverage_tracks"
  mkdir -p "${case_dir}/qualimap"
  mkdir -p "${case_dir}/multiqc"
  mkdir -p "${case_dir}/candidate_variants"

  # ----------------------------
  # 1. FASTQ quality control
  # ----------------------------

  echo "Running FastQC for ${case_name}"

  fastqc "${FASTQ_DIR}/${case_name}"_*.fq.gz \
    -o "${case_dir}/fastqc"


  # ----------------------------
  # 2. Alignment and BAM generation
  # ----------------------------

  echo "Running Bowtie2 alignment for ${case_name}"

  for individual in "${individuals[@]}"; do

    fastq_file="${FASTQ_DIR}/${case_name}_${individual}.fq.gz"
    bam_file="${case_dir}/bam/${case_name}_${individual}.bam"

    bowtie2 \
      -U "${fastq_file}" \
      -x "${REFERENCE_INDEX}" \
      --rg-id "${individual}" \
      --rg "SM:${individual}" \
      -p "${THREADS}" | \
      samtools view -bS - | \
      samtools sort -o "${bam_file}"

    samtools index "${bam_file}"

  done


  # ----------------------------
  # 3. Genome coverage tracks
  # ----------------------------

  echo "Generating coverage tracks for ${case_name}"

  for individual in "${individuals[@]}"; do

    bam_file="${case_dir}/bam/${case_name}_${individual}.bam"

    bedtools genomecov \
      -ibam "${bam_file}" \
      -bg \
      -trackline \
      -trackopts "name=${case_name}_${individual} visibility=2 color=255,30,30" \
      -max 100 \
      > "${case_dir}/coverage_tracks/${case_name}_${individual}.bedgraph"

  done


  # ----------------------------
  # 4. BAM quality control
  # ----------------------------

  echo "Running Qualimap for ${case_name}"

  for individual in "${individuals[@]}"; do

    bam_file="${case_dir}/bam/${case_name}_${individual}.bam"

    qualimap bamqc \
      -bam "${bam_file}" \
      -gff "${TARGET_BED}" \
      -outdir "${case_dir}/qualimap/${case_name}_${individual}"

  done


  # ----------------------------
  # 5. MultiQC report
  # ----------------------------

  echo "Running MultiQC for ${case_name}"

  multiqc "${case_dir}" \
    -o "${case_dir}/multiqc" \
    -n "multiqc_report_${case_name}.html"


  # ----------------------------
  # 6. Variant calling with FreeBayes
  # ----------------------------

  echo "Running FreeBayes for ${case_name}"

  freebayes \
  -f "${REFERENCE_FASTA}" \
    -m 20 \
    -C 5 \
    -Q 10 \
    --min-coverage 10 \
    "${case_dir}/bam/${case_name}_mother.bam" \
    "${case_dir}/bam/${case_name}_father.bam" \
    "${case_dir}/bam/${case_name}_child.bam" \
    > "${case_dir}/${case_name}.vcf"


  # ----------------------------
  # 7. Sort sample order in VCF
  # ----------------------------

  echo "Sorting VCF sample order for ${case_name}"

  bcftools query -l "${case_dir}/${case_name}.vcf" | sort \
    > "${case_dir}/${case_name}.samples.txt"

  bcftools view \
    -S "${case_dir}/${case_name}.samples.txt" \
    "${case_dir}/${case_name}.vcf" \
    > "${case_dir}/${case_name}.sorted.vcf"


  # ----------------------------
  # 8. Variant filtering by inheritance model
  # ----------------------------

  echo "Filtering candidate variants for ${case_name}"

  candidate_vcf="${case_dir}/candidate_variants/${case_name}.candidate_variants.vcf"

  grep "^#" "${case_dir}/${case_name}.sorted.vcf" > "${candidate_vcf}"

  if [ "${inheritance_model}" = "AD" ]; then

    # Autosomal dominant / de novo pattern:
    # parents are reference, child is heterozygous
    grep "0/0.*0/0.*0/1" "${case_dir}/${case_name}.sorted.vcf" >> "${candidate_vcf}"

  elif [ "${inheritance_model}" = "AR" ]; then

    # Autosomal recessive pattern:
    # parents are heterozygous carriers, child is homozygous alternate
    grep "0/1.*0/1.*1/1" "${case_dir}/${case_name}.sorted.vcf" >> "${candidate_vcf}"

  else

    echo "Invalid inheritance model: ${inheritance_model}"
    exit 1

  fi


  # ----------------------------
  # 9. Keep variants inside target regions
  # ----------------------------

  echo "Filtering candidate variants by target regions"

  target_vcf="${case_dir}/candidate_variants/${case_name}.candidate_variants_target_regions.vcf"

  grep "^#" "${candidate_vcf}" > "${target_vcf}"

  bedtools intersect \
    -a "${candidate_vcf}" \
    -b "${TARGET_BED}" \
    -u \
    >> "${target_vcf}"

  echo "${case_name} completed."

done

echo "All WES cases completed."
