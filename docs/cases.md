# Case inheritance models

This project includes five family-trio whole-exome sequencing cases.

Each case includes three individuals:

- mother
- father
- child

## Case list

| Case | Inheritance model |
|---|---|
| case623 | Autosomal dominant |
| case646 | Autosomal recessive |
| case669 | Autosomal dominant |
| case676 | Autosomal dominant |
| case751 | Autosomal dominant |

## Filtering logic

### Autosomal dominant / de novo model

For autosomal dominant cases, candidate variants were selected using a pattern where the child carries the variant while both parents do not.

Expected simplified genotype pattern:

```text
mother: 0/0
father: 0/0
child: 0/1

## Autosomal recessive model

For autosomal recessive cases, candidate variants were selected using a pattern where both parents are heterozygous carriers and the child is homozygous alternate.

Expected simplified genotype pattern:

mother: 0/1
father: 0/1
child: 1/1

Raw FASTQ, BAM and VCF files are not included in this repository.
