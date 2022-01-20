# UpSftp

I used Yuki Hiroshi's upftp.pl to update the home page with FTPS.

But I wanted to try SFTP.

- [upftp.pl](https://gist.github.com/hyuki0000/f58ccabccba37b93dbb5823d4f019341) 

At first I tried to put Net::SFTP, but I couldn't get it.

And after a lot of research, I found information that Net::SFTP::Foreign is used when using Perl.

I immediately put it in with cpam. He easily recognized it.

I got a message saying that IO::Pty is also needed, so I installed this as well.

In the case of my contracted xserver, SFTP could not be used on standard port 21, so I specified it in the configuration option.

I was surprised that it works without setting ssh-key.

Since it's a Linux environment, I think OpenSSH reads the config file by itself, but I'm not sure if it's okay in any environment.
