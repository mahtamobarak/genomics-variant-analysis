# Variant prioritization strategy

After candidate variants were selected from VCF files, variants were further assessed using functional annotation and biological interpretation.

## Variant annotation

Candidate VCF files can be uploaded to or processed with tools such as:

- Ensembl Variant Effect Predictor (VEP)
- ANNOVAR
- SnpEff

The goal is to evaluate the possible functional impact of each variant.

## Annotation features

Important annotation fields include:

- affected gene
- transcript
- variant consequence
- predicted protein effect
- population allele frequency
- known clinical significance
- disease association
- inheritance model compatibility

## Transcript filtering

Variants can be prioritized based on transcript relevance.

In this project, interpretation focused on variants aligning with curated RefSeq transcripts when possible.

## Phenotype association

Variants can be further filtered based on whether the affected gene is associated with relevant clinical phenotypes or known disease terms.

Useful resources include:

- OMIM
- ClinVar
- Ensembl VEP annotation
- gene-disease databases

## Candidate variant selection

Final candidate variants were prioritized based on:

- inheritance model
- variant consequence
- predicted functional impact
- rarity in population databases
- gene relevance to phenotype
- disease association evidence

## Data availability

Annotated VCF files and patient-specific variant results are not included in this repository.
