export MUNGEUSER=1001
sudo groupadd -g $MUNGEUSER munge
sudo useradd -u $MUNGEUSER -g $MUNGEUSER -c "Munge Uid 'N'" -s /bin/bash -m munge
export SLURMUSER=1002
sudo groupadd -g $SLURMUSER slurm
sudo useradd -u $SLURMUSER -h $SLURMUSER -c "SLURM workload manager" -s /bin/bash -m slurm

sudo apt-get update
sudo apt-get autoremove
sudo apt-get autoclean
sudo apt-get install build-essential git ruby ruby-dev libpam0g-dev libmariadb-client-lgpl-dev libmysqlclient-dev -y

mkdir slurm
cd slurm
git clone https://github.com/Adron55/slurm-base.git
cd ..

sudo apt-get install libmunge-dev libmunge2 munge -y
sudo systemctl enable munge
sudo system start munge

sudo apt-get install mariadb-server -y
sudo update-rc.d mysql enable
sudo service mysql start
sudo mysql -u root

create database slurm_acct_db;
create user 'slurm'@'localhost';
set password for 'slurm'@'localhost' = password('slurmdbpass');
grant usage on *.* to 'slurm'@'localhost';
grant all privileges on slurm_acct_db.* to 'slurm'@'localhost'
flush privileges;
exit;

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/install.sh
source ./install.sh



