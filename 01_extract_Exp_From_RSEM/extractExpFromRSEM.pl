#!/usr/bin/perl

#please contact: tianwei@genomics.cn

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;

my ($List, $int, $C_gene, $C_count, $Outfile);
GetOptions(
	"list:s" => \$List,
	"cg:i" => \$C_gene,
	"cc:i"=> \$C_count,
	"int:i"=> \$int,
	"Outfile:s" => \$Outfile
);
if (!$List) {
	print STDERR <<USAGE;
Usage: perl $0 [options]
Options:
	* -list       list for all Expression from RSEM, format<SampleID FilePath>
	* -cg	   column for gene, i.e., the first column is for gene, so use '1'
	* -cc	   column for count, i.e., the 4th columi s for gene counts, so use '4'
	* -int	   if the number of count should be changed to integer int(1) or as default int(0)
	  -Outfile       Outfile
E.g.:
	perl $0 -list sample.list -outdir -cg 1 -cc 4 -int 1 -Outfile ./all_exp.txt 

USAGE
	exit;
}

$Outfile  ||= "./all_exp.txt";

my %list  = ();
my @samples = ();

open LIST,$List or die $!;
while (<LIST>) {
	next if (/^#/ || /^\s*$/);
	chomp; my @a = split /\s+/;
	push @samples,$a[0];
	open (LS,$a[1]) || die $!;
	while(<LS>){
		chomp;
		next if (/^gene/m);
		my @items=split /\s+/;
		if($int == 1){
			if($items[$C_count-1] < 1){
				$list{$items[$C_gene-1]}{$a[0]} = 1;
			}else{
				$list{$items[$C_gene-1]}{$a[0]} = int($items[$C_count-1]);
			}
		}else{
			$list{$items[$C_gene-1]}{$a[0]} = $items[$C_count-1];
		}
	}
	close LS;
}
close LIST;

my $print_out=join("\t","gene_id",@samples);
foreach my $gene(sort keys %list){
	$print_out.="\n$gene";
	foreach my $sample(@samples){
		$list{$gene}{$sample} ||= 0;
		$print_out.="\t$list{$gene}{$sample}";
	}
}

open (O,">$Outfile");
print O "$print_out\n";
close O;
