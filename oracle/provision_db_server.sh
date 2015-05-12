#!/bin/bash

export ORACLE_SYSTEM_PASSWORD=secret
export ORACLE_CLIENT_APPLICATION_PASSWORD=secret

#### configure swap space ####
# taken from https://programmaticponderings.wordpress.com/2013/12/19/scripting-linux-swap-space/

# size of swapfile in megabytes
swapsize=1024
# Use 1024 MB since that we are giving the box 512 MB RAM

# does the swap file already exist?
grep -q "swapfile" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
    echo 'swapfile not found. Adding swapfile.'
    fallocate -l ${swapsize}M /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap defaults 0 0' >> /etc/fstab
else
    echo 'swapfile found. No changes made.'
fi

# output results to terminal
cat /proc/swaps
cat /proc/meminfo | grep Swap
#### end swap configuration ####

# oracle dependencies
sudo yum install -y libaio.x86_64
sudo yum install -y bc

sudo yum install -y unzip

unzip /vagrant/oracle-xe-11.2.0-1.0.x86_64.rpm.zip -d /home/vagrant

sudo mkdir /xe_logs

sudo su -c 'rpm -ivh  /home/vagrant/Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm > /xe_logs/XEsilentinstall.log'

sudo su -c '/etc/init.d/oracle-xe configure responseFile=/vagrant/xe.rsp >> /xe_logs/XEsilentinstall.log'

source /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh

# enable remote access
sqlplus -s /nolog <<EOF
connect system/${ORACLE_SYSTEM_PASSWORD}
exec dbms_xdb.setlistenerlocalaccess(false);
quit
EOF

# create database
sqlplus -s /nolog <<EOF
connect system/${ORACLE_SYSTEM_PASSWORD}
create user client_application identified by ${ORACLE_CLIENT_APPLICATION_PASSWORD};
grant CREATE SESSION, ALTER SESSION, CREATE DATABASE LINK, -
  CREATE MATERIALIZED VIEW, CREATE PROCEDURE, CREATE PUBLIC SYNONYM, -
  CREATE ROLE, CREATE SEQUENCE, CREATE SYNONYM, CREATE TABLE, - 
  CREATE TRIGGER, CREATE TYPE, CREATE VIEW, UNLIMITED TABLESPACE -
  to client_application;
exit
EOF

