## sort.pl
## sort filelist for upftp.pl
## Created in 2022.01.18 by Minoru Yamada.

# File list (in fullpath)
my $filelist = "filelist.txt";

# Get timestamp from $filelist
my $atime = (stat $filelist)[8];
my ($sec,$min,$hour,$mday,$month,$year,$wday,$stime) = localtime($atime);
my $stamp = sprintf("%04d%02d%02d", $year+1900,$month+1,$mday);

open(IN, $filelist) || die('FILE OPEN ERROR!');
my @file = sort { $a cmp $b } <IN>;
close(IN);

# Backup
my $rename = "backup/$stamp.txt";
rename $filelist , $rename;

open(OUT, ">$filelist");
print OUT @file;
close(OUT);
