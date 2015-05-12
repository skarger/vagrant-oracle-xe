- Download Oracle 11gR2 XE from http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html
- Choose "Oracle Database Express Edition 11g Release 2 for Linux x64"
- Docs: http://docs.oracle.com/cd/E17781_01/index.htm
- Put the downloaded zip file in this directory so that it will be available in the /vagrant directory on the CentOS vagrant box.
- Verify the settings in xe.rsp, which is used when installing Oracle in the vagrant provisioning script. These settings include the ports that Oracle will run on and the system password. Default is 'secret' for this test environment.
- `vagrant up`
- Add the following to /etc/tnsnames.ora
```
XE =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 127.0.0.1)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = XE)
    )
  )
```
