#!/usr/bin/perl
#filter_alignments_on_length_and_missing_data.pl
use strict;
use warnings;
# A program to check for sequences with a lot of missing data in alignments generated by Guidance (http://guidance.tau.ac.il/source.php) and to filter on alignment length
# Requires an input file that contains all the lines in the input datasets with the name of the dataset appended before each sequence line
# e.g. generated with "grep -v ">" *_MUSCLE.MSA.MUSCLE.Without_low_SP_Col.With_Names.fasta > All_sequence_lines_from_guidance_results.MSA.MUSCLE.Without_low_SP_Col.With_Names.txt"
# Output of the script is a list of datasets that include sequences which have <10% non-gap characters and/or where the alignment length is <300 characters
# This output can be further parsed with "sort" and "uniq" to get a unique list of datasets that should be filtered

# See comments below for further information on how this script works
# Usage: perl filter_alignments_on_length_and_missing_data.pl

#Declare and initialize variables
my $infile;
my $current_line;
my @current_line_parts= ();
my $current_sequence;
my $current_sequence_length;
my $current_sequence_without_gaps;
my $number_of_non_gap_characters;
my $percent_non_gap_characters;

#Ask user for the path to the input file
print "Please enter the path to the file with the alignment lines to parse:\n";
$infile = <STDIN>;
chomp $infile;

#Create output file for saving results in, or print an error if file cannot be made
open (OUTFILE, ">>Datasets_to_filter_out.txt") or die "Datasets_to_filter_out.txt\": $!\n";

#Open input file, or print an error if file cannot be opened
open (INFILE, "<$infile") or die "Could not open file \"$infile\": $!\n";

#Read in input file, one line at a time
while (<INFILE>) {
  	#save a copy of the current line into a scalar
  	$current_line = $_;
 	#remove the newline character from the current line
 	chomp $_;
 	#split current line to separate out elements and add it to an array
 	@current_line_parts = split(/\:/, $_);
	#save the current sequence in a scalar
 	$current_sequence = $current_line_parts[1];
 	#get the length (number of characters) in the sequence and save in a scalar
 	$current_sequence_length = length($current_sequence);
 	#replace all the gap characters in the sequence
 	$current_sequence =~ s/\-//g;
 	#get the length (number) of non-gap characters in the sequence and save in a scalar
 	$number_of_non_gap_characters = length($current_sequence);
 	#calculate the percentage of non-gap characters
 	$percent_non_gap_characters = ($number_of_non_gap_characters/$current_sequence_length)*100;
 	#check to see if there are fewer than 10% non-gap characters and/or the length of the alignment is <300
 	if (($percent_non_gap_characters < 10) || ($current_sequence_length < 300)) {
 		#if so, save the name of the current dataset to the output file
 		print OUTFILE "$current_line_parts[0]\n";
	}  	 	
}
 	

#Close input file
close INFILE;

#Close output files
close OUTFILE;

#exit the program
exit;