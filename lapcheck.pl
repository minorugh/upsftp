#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use feature 'say';

open(DATA, "filelist.txt");

my $switch = 'o';
#my $switch = 'u';

my %count;
for (<DATA>) {
    $count{$_}++;
}
if ($switch eq 'o') {
    my @overlap = grep {$count{$_} >= 2} keys %count;
    say "overlap:";
    say @overlap;
} elsif ($switch eq 'u') {
    my @unique = grep {$count{$_} == 1} keys %count;
    say "unique:";
    say @unique;
}
close(DATA);
