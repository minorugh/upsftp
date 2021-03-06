# UpSFTP

## Upload file over SFTP with Net::SFTP::Foreign

This program is a modification of Hiroshi Yuki's upftp.pl for use with SFTP.

- [upftp.pl](https://gist.github.com/hyuki0000/f58ccabccba37b93dbb5823d4f019341) 

For the program to work, you must be able to use perl and SSH into a remote server.

## Install module

Net::SFTP::Foreign does not require a bunch of additional modules and external libraries
to work, just the OpenBSD SSH client (or any other client compatible enough).

I have perlbrew and cpanm installed on Debian Linux, 
so I installed the modules with cpanm.

```perl
$ cpanm Net::SFTP::Foreign IO::Pty
```

## Configuration

The main settings are as follows

```perl
########################################
# Configuration
########################################
# Show debug info: 0 (nodebug), 1 (terse), 2 (verbose)
my $debug = 0;
# Show update info.
my $show_update = 1;
# Your SFTP host name.
my $hostname = 'yoursftp.doain';
# Your SFTP portnumber.
my $portnumber = 'portnumber';
# Your SFTP user name.
my $username = 'yourname';
# Optional settings
my $moreoptions = [ -o => 'StrictHostKeyChecking no' ];
# Remote root directory (in fullpath)
my $remoterootdir = '/home/youraccount/public_html';
# Local root directory (in fullpath)
my $localrootdir = "/home/myname";
# File list (in fullpath)
my $filelist = "/home/myname/filelist.txt";
########################################
# End of configuration.
########################################
```

- The standard port for SFTP is usually 22, but if a port is set separately, set it.
- In my case, I automatically entered the passphrase at login and executed ssh-key, so I didn't need to set the keypath in sftp.pl.

## Filelist

UpSftp checks the filelist's timestamp to upload only updated files.

- In the filelist, describe the filepath and filename under localrootdir.
- When start UpSftp, the ones written in the filelist will be uploaded one by one.
- After uploading, the update time will be added to the filelist.
- Compare the time stamp in the filelist with the updatefile and upload only the new updatefile.

