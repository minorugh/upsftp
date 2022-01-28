## # This is Sort.pl, Version 1.0
# Copyright (C) 2022 by Minoru Yamada.
## Sort filelists and automatically remove duplicates.

my $filelist = "filelist.txt";

# Get timestamp from $filelist
my $atime = (stat $filelist)[8];
my ($sec,$min,$hour,$mday,$month,$year,$wday,$stime) = localtime($atime);
my $stamp = sprintf("%04d%02d%02d", $year+1900,$month+1,$mday);

open(IN, $filelist) || die('FILE OPEN ERROR!');
# Sort filelist
my @file = sort { $a cmp $b } <IN>;
# Remove duplicates
my %count;
@file = grep( !$count{$_}++, @file);
close(IN);

# Backup
my $rename = "backup/$stamp.txt";
rename $filelist , $rename;

# Update filelist
open(OUT, ">$filelist");
print OUT @file;
close(OUT);

print "Completed sorting and removing duplicates!\n";
sleep(1);
