
cnode_ips=('192.168.1.110','192.168.1.111')
slurm_link=slurm-21.08.3

${cnode_ips[0]}

export MUNGEUSER=1001
sudo groupadd -g $MUNGEUSER munge
sudo useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SLURMUSER=1002
sudo groupadd -g $SLURMUSER slurm
sudo useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm

sudo apt-get install munge libmunge-dev libmunge2 -y

sudo /usr/sbin/create-munge-key

sudo -i
scp /etc/munge/munge.key /etc/passwd /etc/shadow /etc/group manager@${cnode_ips[0]}:~
scp /etc/munge/munge.key /etc/passwd /etc/shadow /etc/group manager@${cnode_ips[1]}:~
# Install munge packages, copies munge.key and slurm/munge users from the headnode to the compute nodes
# cnode1 actions
ssh manager@${cnode_ips[0]} 'bash -s' < node.sh &
#exit
# cnode2 actions
ssh manager@${cnode_ips[1]} 'bash -s' < node.sh &
# run cnode2 script here
#exit
exit

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
exit



ssudo systemctl start slurmdbd
sudo systemctl enable slurmdbd
sudo systemctl status slurmdbd

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/slurm.conf
mv slurm.conf /etc/slurm
sudo ln -s /etc/slurm/slurm.conf /usr/local/etc/slurm.conf

sudo mkdir /var/spool/slurmctld
sudo chown slurm:slurm /var/spool/slurmctld
sudo chmod 755 /var/spool/slurmctld
sudo mkdir  /var/log/slurm
sudo touch /var/log/slurm/slurmctld.log
sudo touch /var/log/slurm/slurm_jobacct.log /var/log/slurm/slurm_jobcomp.log
sudo chown -R slurm:slurm /var/log/slurm/

wait

systemctl enable slurmctld.service
systemctl start slurmctld.service
systemctl status slurmctld.service