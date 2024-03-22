
cnode_ips=('192.168.1.110','192.168.1.111')
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
scp /etc/munge/munge.key /etc/passwd /etc/shadow /etc/group manager@${cnode_ips[0]}:~
scp /etc/munge/munge.key /etc/passwd /etc/shadow /etc/group manager@${cnode_ips[1]}:~
# Install munge packages, copies munge.key and slurm/munge users from the headnode to the compute nodes
ssh manager@${cnode_ips[0]} 'bash -s' < node.sh &
ssh manager@${cnode_ips[1]} 'bash -s' < node.sh &
exit

sudo chown -R munge: /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/

sudo systemctl enable munge
sudo systemctl start munge

sudo apt-get install mariadb-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
mysql_secure_installation

sudo echo "[mysqld]\n innodb_buffer_pool_size=1024M\n innodb_log_file_size=64M\n innodb_lock_wait_timeout=900" > /etc/my.cnf.d/innodb.cnf

sudo systemctl stop mariadb
sudo mv /var/lib/mysql/ib_logfile? /tmp/
sudo systemctl start mariadb

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/install.sh
chmod +x install.sh
./install.sh

mysql -u root -p
grant all on slurm_acct_db.* TO 'slurm'@'localhost' identified by 'some_pass' with grant option;
create database slurm_acct_db;
exit

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/slurm%20files/slurmdbd.conf
sudo mv slurmdbd.conf /etc/slurm/

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