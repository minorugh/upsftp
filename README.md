# UpSftp

## Upload file over SFTP with Net::SFTP::Foreign

This program is a modification of Hiroshi Yuki's upftp.pl for use with SFTP.

- [upftp.pl](https://gist.github.com/hyuki0000/f58ccabccba37b93dbb5823d4f019341) 

For this program to work, you need to be able to use perl and ssh on your terminal,

and have an environment where you can ssh to a remote server.

## Install module

I have perlbrew and cpanm installed on Debian Linux, 

so I installed the modules needed for this program with cpanm.

```perl
$ cpanm Net::SFTP::Foreign IO:Pty
```

## 

The standard port for SFTP is usually 22, but if a port is set separately, set it.

In my case it worked without setting ssh-key, but I'm not sure if that's the case in any environment.

