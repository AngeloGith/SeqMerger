# # BioSeqMerger

# Requeriments 

* Bio::SeqIO
* File::Basename

# Run   

perl BioSeqMerger.pl file1 file2 .. > output.fasta  

# Description

This Perl script serves as a powerful tool for bioinformatics specialists working with genomic sequence data. An easy to use perl script "BioSeqMerger" is designed to concatenate sequences from multiple aligned FASTA files.

# Key functionalities include:

* Sequence Concatenation
* Position Tracking
* Summary Report

This script is an essential asset for researchers and professionals in the field, streamlining the process of managing and analyzing large genomic datasets.


# Input File Guide

To ensure the smooth operation of the script, your input files should adhere to the following format and guidelines:

File Format: The input files should be in FASTA format, a single-line description (preceded by a '>') followed by lines of sequence data.

Sequence ID: Each sequence within the files should have a unique identifier, which is specified in the description line (the line starting with '>'). The script uses these IDs to concatenate sequences across files.

Sequence Length: All sequences within each fasta aligned file should have the same length. This is to ensure that the concatenation process, which is based on sequence positions, functions correctly.
