
cnode_ips=('192.168.1.110','192.168.1.111')

export SLURMUSER=990
sudo groupadd -g $SLURMUSER slurm
sudo useradd -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm -s /bin/bash slurm

export MUNGEUSER=991
sudo groupadd -g $MUNGEUSER munge
sudo useradd -m -c "MUNGE Uid 'N' " -d /var/lib/munge -u $MUNGEUSER -g munge -s /sbin/nologin munge

sudo apt-get install munge libmunge-dev libmunge2 rng-tools -y
sudo rngd -r /dev/urandom

sudo /usr/sbin/create-munge-key -r
sudo -i
dd if=/dev/urandom bs=1 count=1024 > /etc/munge/munge.key 
exit
sudo chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key

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

sudo systemctl start munge
sudo systemctl enable munge

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/bash%20scripts/install.sh
chmod +x install.sh
./install.sh

sudo mkdir /etc/slurm 
sudo touch /var/log/slurm.log 
sudo touch /var/log/SlurmctldLogFile.log 
sudo touch /var/log/SlurmdLogFile.log 
sudo mkdir /var/spool/slurmctld 
sudo chown slurm:slurm /var/spool/slurmctld 
sudo chmod 755 /var/spool/slurmctld 
sudo touch /var/log/slurmctld.log
sudo chown slurm:slurm /var/log/slurmctld.log
sudo touch /var/log/slurm_jobacct.log
sudo chown slurm:slurm /var/log/slurm_jobacct.log

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/slurm%20files/slurm.conf
mv slurm.conf /etc/slurm
sudo ln -s /etc/slurm/slurm.conf /usr/local/etc/slurm.conf

wait

sudo systemctl start slurm
sudo systemctl enable slurm

sudo apt install libcgroup-tools -y
sudo systemctl start cgconfig
sudo systemctl enable cgconfig

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/slurm%20files/cgroups.conf
sudo mv cgroups.conf /etc/slurm/cgroups.conf
wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/slurm%20files/cgroup_allowed_device_file.conf
sudo mv cgroup_allowed_device_file.conf etc/slurm/cgroup_allowed_device_file.conf

sudo ln -s /etc/slurm/cgroup.conf /usr/local/etc/cgroup.conf
sudo ln -s /etc/slurm/cgroup_allowed_devices_file.conf /usr/local/etc/cgroup_allowed_devices_file.conf

squeue