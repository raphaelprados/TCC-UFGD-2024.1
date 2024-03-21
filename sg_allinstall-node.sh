
cnode1_ip=192.168.1.109
cnode2_ip=192.168.1.110
slurm_link=slurm-21.08.3

export MUNGEUSER=1001
sudo groupadd -g $MUNGEUSER munge
sudo useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SLURMUSER=1002
sudo groupadd -g $SLURMUSER slurm
sudo useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm

sudo chown -R munge: /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo chown -R munge: /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/

sudo systemctl enable munge
sudo systemctl start munge

munge -n | unmunge
munge -n | ssh manager@$cnode1_ip unmunge
munge -n | ssh manager@$cnode2_ip unmunge

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