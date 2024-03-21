
export MUNGEUSER=1001
sudo groupadd -g $MUNGEUSER munge
sudo useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SLURMUSER=1002
sudo groupadd -g $SLURMUSER slurm
sudo useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm

sudo apt-get install libmunge-dev libmunge2 munge -y
sudo mv munge.key /etc/munge/

sudo chown -R munge: /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo cexec chown -R munge: /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo cexec chmod 0700 /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/

sudo systemctl enable munge
sudo systemctl start munge

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/install.sh
chmod +x install.sh
./install.sh

sudo apt-get install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation

sudo echo "[mysqld]\n innodb_buffer_pool_size=1024M\n innodb_log_file_size=64M\n innodb_lock_wait_timeout=900" > /etc/my.cnf.d/innodb.cnf

systemctl stop mariadb
mv /var/lib/mysql/ib_logfile? /tmp/
systemctl start mariadb

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/slurm.conf

sudo mkdir /var/spool/slurmd
sudo chown slurm: /var/spool/slurmd
sudo chmod 755 /var/spool/slurmd
sudo mkdir /var/log/slurm/
sudo touch /var/log/slurm/slurmd.log
sudo chown -R slurm:slurm /var/log/slurm/slurmd.log

sudo systemctl enable slurmd.service
sudo systemctl start slurmd.service
sudo systemctl status slurmd.service