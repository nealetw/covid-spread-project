# Authors: 
# Brandon Starcheus
# Tim Neale
# Alex Shiveley
# Daniel Hackney

# Input a CSV from a Google Form of Student Data.
# Output a cleansed CSV with columns for each health condition.

# Usage:   perl perlScript.pl <Input CSV> <Output CSV>
# Example: perl perlScript.pl Test\ Survey\ \(Responses\)\ -\ Form\ Responses\ 1.csv 1-Perl-Output.csv

use strict; 
use warnings;

my $infile = $ARGV[0] or die;
my $outputfile = $ARGV[1] or die;
open(my $data, '<', $infile) or die;
open(my $outfile, '>', $outputfile) or die;

my @conditionNames = ('Asthma','Heart Conditions','Diabetes','High Blood Pressure','Immunocompromised','Smoker','Other');
my $firstLine = 1;

while (my $line = <$data>)
{
    chomp $line;
    
    if ($firstLine) {
        # Skip the first line, data header
        $firstLine = 0;
        $line = <$data>;
        chomp $line;
        print $line;
    } else {
        print $outfile "\n";
    }

    # Split the line and store it
    # inside the words array
    my @words = split ",", $line;
    
    # Change 1st to 1, 2nd to 2, etc
    $words[4] = substr($words[4], 0, 1);
    
    # Remove quotation marks and spaces from all conditions
    for (my $i = 10; $i <= $#words; $i++)
    {
        $words[$i] = substr($words[$i], 1);
    }
    $words[$#words] = substr($words[$#words], 0, -1); # Remove final quotation mark

    my @tempConditions = @words[10..$#words];
    my %conditionHash = map { $_ => 1 } @tempConditions;
    @words = @words[1..9];

    for (my $i = 0; $i <= $#conditionNames; $i++) {
        # If a student has a condition, mark it as a 1
        if(exists($conditionHash{$conditionNames[$i]})) {
            push(@words, '1');
        } else {
            push(@words, '0');
        }
    }

    # Put into new CSV file
    for (my $i = 0; $i < $#words; $i++)
    {
        print $outfile "$words[$i],";
    }
    print $outfile "$words[$#words]";
}
close($outfile);