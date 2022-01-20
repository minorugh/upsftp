# UpSftp

I used upftp.pl by Hiroshi Yuki to update the homepage by FTP, but I thought that it could be used by SFTP and tried it.


- [upftp.pl](https://gist.github.com/hyuki0000/f58ccabccba37b93dbb5823d4f019341) 

At first, I put in Net :: SFTP, but it didn't recognize it, and after a lot of research I found information that he would use Net :: SFTP :: Foreign in Perl, so I tried putting it in with cpam. He recognized it easily. I got a message asking me to include IO :: Pty, so I installed this as well.

In the case of my contracted xserver, SFTP could not be used with standard port 21, so I specified it in the configuration option. I was surprised that it worked without setting the private key. Since it's a Linux environment, he thinks OpenSSH is reading the config file himself, but I'm not sure if he's OK in any environment.

Even with upftp, I used Net :: FTPSSL for encryption. I'm not sure if FTPS or SFTP is safer, but in my case I set the SSH private key to be as strong as 40 digits, so he thinks it's safer if SFTP works.
