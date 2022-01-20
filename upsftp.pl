#!/usr/bin/perl
#
# This is UpSftp, Version 1.0
# Copyright (C) 2022, by Minoru Yamada.
# https://minorugh.xsrv.jp/post/2022/0119-upsftp/
# https://gist.github.com/minorugh/ba4657ed692ab3ef61006fe6b687eeee
# This program is modification of upftp.pl by Hiroshi Yuki, Use with SFTP.
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
use strict;
use warnings;
use Net::SFTP::Foreign;

########################################
# Configuration
########################################
# Show debug info: 0 (nodebug), 1 (terse), 2 (verbose)
my $debug = 0;
# Show update info.
my $show_update = 1;
# Your SFTP host name.
my $hostname = 'yoursftp.doain';
# Your SFTP port.
my $sftpport = 'sftpport';
# Your SFTP user name.
my $username = 'yourname';
# Remote root directory (in fullpath)
my $remoterootdir = '/home/youraccount/public_html';
# Get HOME directory from environment variables
my $home = $ENV{"HOME"};
# Local root directory (in fullpath)
my $localrootdir = "$home/www";
# File list (in fullpath)
my $filelist = "$home/upsftp/filelist.txt";
# Binary file extension
my @binary_extension = qw(
    gif jpg png class pdf zip lzh tar gz tgz
);

########################################
# End of configuration.
########################################
my $sftp;
my @newfilelist;

&upsftp;
exit(0);

sub upsftp {
    if ($debug) {
		print "Simulation only, I do not transfer any file.\n";
    }
    unless ($hostname) {
        print "\$hostname is empty, abort.\n";
        return;
    }
    unless ($username) {
        print "\$username is empty, abort.\n";
        return;
    }
    unless ($sftpport) {
        print "\$hostport is empty, abort.\n";
        return;
    }
    unless ($remoterootdir) {
        print "\$remoterootdir is empty, abort.\n";
        return;
    }
    unless ($localrootdir) {
        print "\$localrootdir is empty, abort.\n";
        return;
    }
    unless ($filelist) {
        print "\$filelist is empty, abort.\n";
        return;
    }
    print "filelist is $filelist\n" if ($debug);
    if (!open(FILELIST, $filelist)) {
        print "$filelist is not found.\n";
        return;
    }
    while (<FILELIST>) {
        chomp;
        next if (/^#/);
        my ($filename, $updatetime) = split(/,/);
        $updatetime = 0 if (not defined($updatetime) or $updatetime eq "");
        print "$filename = $updatetime\n" if ($debug > 1);
        my $mtime = (stat("$localrootdir/$filename"))[9];
        $mtime = 0 if (not defined($mtime) or $mtime eq "");
        print "mtime = $mtime\n" if ($debug > 1);
        if (defined($mtime) and $mtime > $updatetime) {
            print "Update $filename\n" if ($debug or $show_update);
			&sftp_put("$localrootdir/$filename", "$remoterootdir/$filename");
        } else {
            print "Skip $filename\n" if ($debug);
        }
        my $curtime = time;
        push(@newfilelist, "$filename,$curtime\n");
    }
    close(FILELIST);
    if (!open(FILELIST, "> $filelist")) {
        print "$filelist: Cannot create.\n";
        exit(-1);
    }
    print FILELIST @newfilelist;
    close(FILELIST);
}

# Put $localfile to $remotefile.
sub sftp_put {
    my ($localfile, $remotefile) = @_;
    $sftp = Net::SFTP::Foreign->new($hostname,
									port=> $sftpport,
									user=> $username,
									more=>[-o =>'StrictHostKeyChecking no']);
    $sftp->put($localfile, $remotefile);
}
1;
