

#Example:  generatecert.sh <Host FQDN> <root> <root Password>
# At agent side:  usermod -aG puppet vagrant


#!/bin/bash -x

# Just run it from Puppet master.

#This script willregenerate SSL cert for node and get it signed by puppet master for trusted communication.
# It can be handy if you want to do it quickly and do not want to switch back and forth between master and node machine
# for  running the required commands.


echo "firing commands from puppet master"
#mkdir /home/testAAA
#mkdir /home/testBBB


sshpass -f <(printf '%s\n' vagrant) ssh vagrant@node02.example.com 'sudo puppet agent -vt'
#read -s 'pw?Prompt text'
#puppet agent -vt


#master:
puppet cert clean $1
service puppetmaster restart
service puppetmaster status
pids=$(ps -ef|grep masterport|grep  '8140'|awk '{print $2}')
ps -ef|grep masterport|grep  '8140'
echo $pids
kill -9 $pids
service puppetmaster restart
service puppetmaster status

#Agent:
#sshpass -f <(printf '%s\n' $3) ssh $2@$1 "sudo mv /var/lib/puppet/ssl /home/test/"
sshpass -f <(printf '%s\n' $3) ssh $2@$1 "sudo rm -rf /var/lib/puppet/ssl"
#sshpass -f <(printf '%s^@' $3) ssh $2@$1 'sudo service puppet restart'
#rm -rf /var/lib/puppet/ssl/*

#master:
service puppetmaster restart
puppet cert list

#Agent:
sshpass -f <(printf '%s\n' $3) ssh $2@$1 'sudo service puppet restart'
sshpass -f <(printf '%s\n' $3) ssh $2@$1 'sudo  puppet agent -t'
#puppet cert list

#master:
puppet cert list
puppet cert sign $1


#agent:
sshpass -f <(printf '%s\n' $3) ssh $2@$1 "sudo puppet agent -vt"
