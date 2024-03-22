
sudo mv passwd shadow group /etc/

sudo apt-get install munge libmunge-dev libmunge2 -y
sudo mv munge.key /etc/munge/

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

sudo systemctl start slurmdbd
sudo systemctl enable slurmdbd
sudo systemctl status slurmdbd

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/slurm.conf
sudo mv slurm.conf /etc/slurm/

sudo mkdir /var/spool/slurmd
sudo chown slurm: /var/spool/slurmd /var/run/slurmd.pid /var/log
sudo chmod 755 /var/spool/slurmd  /var/run/slurmd.pid /var/log
sudo mkdir /var/log/slurm/
sudo touch /var/log/slurm/slurmd.log
sudo chown -R slurm:slurm /var/log/slurm/slurmd.log

sudo systemctl enable slurmd.service
sudo systemctl start slurmd.service
sudo systemctl status slurmd.service