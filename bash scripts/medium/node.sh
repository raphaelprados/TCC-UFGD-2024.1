

export MUNGEUSER=1001
sudo groupadd -g $MUNGEUSER munge
sudo useradd -u $MUNGEUSER -g $MUNGEUSER -c "Munge Uid 'N'" -s /bin/bash -m munge
export SLURMUSER=1002
sudo groupadd -g $SLURMUSER slurm
sudo useradd -u $SLURMUSER -h $SLURMUSER -c "SLURM workload manager" -s /bin/bash -m slurm

sudo apt-get update
sudo apt-get autoremove
sudo apt-get autoclean

mkdir slurm
cd slurm
git clone https://github.com/Adron55/slurm-base.git
cd ..

sudo apt-get install libmunge-dev libmunge2 munge -y
sudo mv munge.key /etc/munge/

sudo chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.keysudo systemctl enable munge
sudo systemctl restart munge

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/install.sh
chmod +x install.sh
./install.sh

sudo mkdir /etc/slurm
sudo scp hostname@ip:/etc/slurm/slurm.conf /etc/slurm/

sudo cp slurm-base/gres.conf /etc/slurm/gres.conf
sudo cp slurm-base/cgroup.conf /etc/slurm/cgroup.conf
sudo cp slurm-base/cgroup_allowed_devices_file.conf /etc/slurm/cgroup_allowed_devices_file.confsudo mkdir -p /var/spool/slurm/d

sudo cp slurm-base/slurmd.service /etc/systemd/system/sudo 
sudo systemctl daemon-reload
sudo systemctl enable slurmd
sudo systemctl start slurmd

sudo nano /etc/default/grub

sudo update-grub
sudo reboot

