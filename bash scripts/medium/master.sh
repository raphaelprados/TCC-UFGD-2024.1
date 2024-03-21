
cnode_ips=('192.168.1.110','192.168.1.111')

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

sudo -i
scp /etc/munge/munge.key /etc/passwd /etc/shadow /etc/group manager@${cnode_ips[0]}:~
scp /etc/munge/munge.key /etc/passwd /etc/shadow /etc/group manager@${cnode_ips[1]}:~
# Install munge packages, copies munge.key and slurm/munge users from the headnode to the compute nodes
ssh manager@${cnode_ips[0]} 'bash -s' < node.sh &
ssh manager@${cnode_ips[1]} 'bash -s' < node.sh &
exit

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
chmod +x install.sh
./install.sh

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/slurm.conf
sudo mkdir -p /etc/slurm /etc/slurm/prolog.d /etc/slurm/epilog.d /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm
sudo chown slurm /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm
sudo cp slurm-base/slurmdbd.conf /etc/slurm/
mv slurm.conf /etc/slurm

sudo chmod 600 /etc/slurm/slurmdbd.conf
sudo chmod 644 /etc/slurm/slurm.conf
sudo chown slurm /etc/slurm/slurmdbd.conf /etc/slurm/slurm.conf

wait

cd ~/slurm/
sudo cp slurm-base/slurmdbd.service /etc/systemd/system/
sudo cp slurm-base/slurmctld.service /etc/systemd/system/sudo systemctl daemon-reload
sudo systemctl enable slurmdbd
sudo systemctl start slurmdbd
sudo systemctl enable slurmctld
sudo systemctl start slurmctld