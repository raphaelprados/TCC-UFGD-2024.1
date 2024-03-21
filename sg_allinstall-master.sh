
cnode1_ip=192.168.1.109
cnode2_ip=192.168.1.110
slurm_link=slurm-21.08.3

export MUNGEUSER=1001
sudo groupadd -g $MUNGEUSER munge
sudo useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SLURMUSER=1002
sudo groupadd -g $SLURMUSER slurm
sudo useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm

sudo apt-get install munge libmunge-dev libmunge2 -y

sudo /usr/sbin/create-munge-key

sudo -i
scp /etc/munge/munge.key manager@$cnode1_ip:~
scp /etc/munge/munge.key manager@$cnode2_ip:~
ssh manager@$cnode1_ip 
sudo apt-get install munge libmunge-dev libmunge2 -y
sudo mv munge.key /etc/munge/
exit
ssh manager@$cnode2_ip 
sudo apt-get install munge libmunge-dev libmunge2 -y
sudo mv munge.key /etc/munge/
exit
exit

sudo chown -R munge: /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo chown -R munge: /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/

sudo systemctl enable munge
sudo systemctl start munge

munge -n | unmunge
munge -n | ssh manager@$cnode1_ip unmunge
munge -n | ssh manager@$cnode2_ip unmunge

sudo apt-get install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation

sudo echo "[mysqld]\n innodb_buffer_pool_size=1024M\n innodb_log_file_size=64M\n innodb_lock_wait_timeout=900" > /etc/my.cnf.d/innodb.cnf

systemctl stop mariadb
mv /var/lib/mysql/ib_logfile? /tmp/
systemctl start mariadb

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/install.sh
chmod +x install.sh
./install.sh

sudo apt-get install openssl libssl-dev libpam0g-dev rpmbuild numactl libnuma-dev libnuma1 hwloc libhwloc-dev lua5.3 liblua5.3-dev libreadline-dev librrd-dev libncurses5-dev man2html libibmad5 libibumad-dev -y

wget http://134.100.28.207/files/src/slurm/$slurm_link.tar.bz2
tar xfj $slurm_link.tar.gz2
rm $slurm_link.tar.gz2
cd $slurm_link
./configure --prefix=/usr/local/slurm-19.05.3-2
sudo make
sudo make install
cd ..

mysql -u root -p
grant all on slurm_acct_db.* TO 'slurm'@'localhost' identified by 'some_pass' with grant option;
create database slurm_acct_db;

sudo echo -e "AuthType=auth/munge\n DbdAddr=192.168.1.250\n DbdHost=master\n SlurmUser=slurm\n DebugLevel=4\n LogFile=/var/log/slurm/slurmdbd.log\n PidFile=/var/run/slurmdbd.pid\n StorageType=accounting_storage/mysql\n StorageHost=master0\n StoragePass=some_pass\n StorageUser=slurm\n StorageLoc=slurm_acct_db"
ssudo systemctl start slurmdbd
sudo systemctl enable slurmdbd
sudo systemctl status slurmdbd

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/slurm.conf

sudo mkdir /var/spool/slurmctld
sudo chown slurm:slurm /var/spool/slurmctld
sudo chmod 755 /var/spool/slurmctld
sudo mkdir  /var/log/slurm
sudo touch /var/log/slurm/slurmctld.log
sudo touch /var/log/slurm/slurm_jobacct.log /var/log/slurm/slurm_jobcomp.log
sudo chown -R slurm:slurm /var/log/slurm/

systemctl enable slurmctld.service
systemctl start slurmctld.service
systemctl status slurmctld.service