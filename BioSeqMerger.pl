#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
use File::Basename;

#By Angelo Armijos Carrion.
#run (perl BioSeqMerger.pl file1 file2 .. > output.fasta)

my %seqs;
my %file_positions;
my @file_order;
my $current_position = 1;
my %seq_count;
my $total_seq_count = 0;
my $concatenated_count = 0;
my $not_concatenated_count = 0;
my @concatenated_seq_ids;
my @not_concatenated_seq_ids;

my $usage  = "$0";
while (my $file = shift) {

    if (! -e $file) {
        warn "Warning: File '$file' not found.\n";
        next;
    }

    my $seqio = Bio::SeqIO->new(-file => $file, -format => "fasta");
    my $file_length = 0;
    my $filename = basename($file);
    my %seen_ids;

    while(my $seq = $seqio->next_seq) { 
      my $seq_id = $seq->id();
      my $seq_length = length($seq->seq);

      if (exists $seen_ids{$seq_id}) {
          warn "Warning: Duplicate sequence ID '$seq_id' found in file '$file'.\n";
      }
      $seen_ids{$seq_id} = 1;

      if ($file_length != 0 && $seq_length != $file_length) {
          warn "Warning: Inconsistent sequence lengths found in file '$file'.\n";
      }

      $seqs{$seq_id} .= $seq->seq;
      $file_length = $seq_length if $file_length == 0;
      $seq_count{$seq_id}++;
      $total_seq_count++;
    }

    if ($file_length == 0) {
        warn "Warning: No valid sequences found in file '$file'.\n";
    }

    $file_positions{$filename} = "$current_position-" . ($current_position + $file_length - 1);
    push @file_order, $filename;
    $current_position += $file_length;
}

open(my $summary_fh, '>', 'Summary.txt') or die "Could not open file 'Summary.txt' $!";
foreach my $filename (@file_order) {
    print $summary_fh "$filename = $file_positions{$filename}\n";
}

print $summary_fh "\n\n";

foreach my $seq_id (keys %seq_count) {
    if ($seq_count{$seq_id} > 1) {
        print $summary_fh "$seq_id = concatenated $seq_count{$seq_id} times\n";
        push @concatenated_seq_ids, $seq_id;
        $concatenated_count++;
    } else {
        print $summary_fh "$seq_id = no matches found\n";
        push @not_concatenated_seq_ids, $seq_id;
        $not_concatenated_count++;
    }
}

print $summary_fh "\n\nNot concatenated sequence IDs:\n" . join("\n", @not_concatenated_seq_ids) . "\n";
print $summary_fh "\n\nTotal sequences among all files: $total_seq_count\n";
print $summary_fh "Total concatenated sequences: $concatenated_count\n";
print $summary_fh "Total not concatenated sequences: $not_concatenated_count\n";
close $summary_fh;

foreach my $key (keys %seqs) { 
    print ">$key\n$seqs{$key}\n";
}
