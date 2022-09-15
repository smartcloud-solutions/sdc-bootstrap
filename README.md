# sdc-bootstrap

 sdc-bootstrap is a repository which populates /opt/custom after intial install. 
 This can be useful for your own custom SMF configurations or anything that you
 deem to be a standard requirement for your installation. 

 /opt/custom/share/svc currently has to bash scripts. deploy.sh and bootstrap.sh

 I decided to start this repo as a place to save my custom startup changes to 
 read-only configuration files after boot. In this initial commit it is used for
 primarily updating /etc/ipf/ipf.conf, /etc/ssh/{ssh_config,sshd_config}. 

 The /etc/ipf/ipf.conf is a basic ipf.conf to block traffic on the external nic
 tag. However, it does allow port 2222 from any host. 

 /etc/ssh/ssh_config removes a number of annoying aspects of managing hundreds
 or thousands of compute nodes which generate new host keys on each boot. It
 sets the known_hosts file to /dev/null, disables strict host key checking, and
 finally it sets the local default identity file to /root/.ssh/sdc.id_rsa. 
 
 The last part allows you to ssh into a headnode and then ssh into any compute
 node without having to set the "-i .ssh/sdc.id_rsa" switch to authenticate 
 without a password. 

 These changes to the ssh client may not be acceptible in your environment 
 depending on the compliance levels your business is required to maintain. 
 For our use however, being only used on the admin network to access internal
 compute nodes, it poses no threat. 

 /etc/sshd_config enables a second ssh port "Port 2222". This is just a half
 assed attempt at creating security by obscurity. It isn't really anymore 
 secure than just opening port 22. But since it is a headnode I set a different
 port purposely just to reduce the amount of random brute force login attempts.
 
 Finally after updating the aforementioned configuration files it restarts the
 corresponding services: ipfilter and ssh. 

 There are other aspects that are specific to our operation and are not allowed
 to be commited to the general public so these files are omitted. However you
 could easily adapt this directory, script, and SMF structure to add other 
 dependencies such as a chef client, ldap-client, etc, etc. 

# Installation

 ssh to your headnode and cd to /opt

```
 git clone https://github.com/smartcloud-solutions/sdc-bootstrap custom
 
 # make any custom edits to the config files before the next command.

 svcadm restart ipfilter ssh

 # alternatively you may simply reboot the headnode.
 
 shutdown -i6 -g0 -y
```

 

 Enjoy!
 
 

 John Barfield
