# sdc-bootstrap

 sdc-bootstrap is a repository which populates /opt/custom after intial install
 with useful startup scripts and automatically enabled service manifest files.
 
 This can be useful for your own custom SMF configurations or anything that you
 deem should be a standard boot-time requirement for your headnode installation.

 `/opt/custom/share/svc` currently has two bash scripts:
 
 `deploy.sh` and `bootstrap.sh`. 

## Rationale

 I decided to start this repo as a place to save my custom startup changes to 
 read-only configuration files after boot. In this initial commit, it is used
 primarily for updating `/etc/ipf/ipf.conf`,`/etc/ssh/{ssh_config,sshd_config}`.

### network/ipfilter

 The /etc/ipf/ipf.conf is a basic ipf.conf to block traffic on the external nic
 tag. However, it does allow port 2222 from any host. 

#### ssh client environment 
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

### network/ssh 
 `/etc/sshd_config` enables a second ssh port "Port 2222". This is just a half
 -assed attempt at creating security by obscurity. It isn't really anymore
 secure than just opening port 22. But since this is a headnode I purposely set
 a different port just to reduce the amount of random brute force login attempts
 to the host (and also keep the auth logs somewhat clean). 
 
 Finally after updating the aforementioned configuration files the `deploy.sh`
 script restarts the affected services, which are ipfilter and ssh.

## Final note about this repo
 Honestly there is nothing all that special about this project other than being
 a pre-packaged `/opt/custom` directory tree with a couple of simple changes that 
 I always wished just happened out of the box on installation. If you're new to 
 SmartOS then this could be helpful to you. If you're a veteran you probably 
 shouldn't pay it any attention. This is a very simple project repo which is a 
 backup of my own custom setup/configuration, and I share it with my fellow 
 newbs whom I mentor from time to time.

 There are other aspects of this repo originating from production that are 
 specific to private operations and are not allowed to be commited to github.
 These files will remain omitted. However you could easily adapt any aspect of
 the directory structure, any script, or SMF structure to your environment and 
 add other dependencies such as a chef client, ldap-client, etc, etc, on boot 
 with a simple `git clone` command.
 
 My hope is that cloning this repo makes your life easier to some degree on
 your triton/smartOS headnode.

# Installation

 ssh into your headnode and then `cd /opt`.

```
 git clone https://github.com/smartcloud-solutions/sdc-bootstrap custom
 
 # Note:
 #  Make custom changes to the configuration files before the next command.
 # 
 # If only modifying or verifying the default svc configs then simply run:
 
 svcadm restart ipfilter ssh

 # alternatively you may simply reboot the headnode, I suggest doing this
 # either way just to be sure that it functions properly on boot. 
 
 shutdown -i6 -g0 -y
```
 
### About the author:
---
John Barfield
  
 * Sr. Site-Reliability Engineer @Joyent
 * 20+ year IT Consultant, wanna-be OSS contributor, and Free-Time Entrepreneur
 * Musician|Father|Dork
 * @Joyent:
 - SmartOS/Triton/Manta SRE
 - pkgsrc maintainer
 - Samsung Private Cloud/devOps engineering
