#!/bin/sh

# Wolfpeak Boot Configuration Deployment Script

# Update SSH Client/sshd options
## ssh daemon
## enables port 2222 in addition to 22 for sshd

# ssh client
## updates client config to allow the sdc.id_rsa
## as the identity for compute node connections
## disables strict host key checking

cp /opt/custom/etc/{ssh,sshd}_config /etc/ssh/

# Update ipf.conf and restart ipf/ssh
cp /opt/custom/etc/ipf/ipf.conf /etc/ipf/ipf.conf

svcadm restart ipfilter ssh
