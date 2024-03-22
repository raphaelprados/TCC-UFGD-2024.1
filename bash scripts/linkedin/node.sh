
sudo mv passwd shadow group /etc/

sudo apt-get install munge libmunge-dev libmunge2 -y
sudo mv munge.key /etc/munge/
sudo chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key

sudo systemctl start munge
sudo systemctl enable munge

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/bash%20scripts/install.sh
chmod +x install.sh
./install.sh

sudo mkdir /etc/slurm 
sudo touch /var/log/slurm.log 
sudo touch /var/log/SlurmctldLogFile.log 
sudo touch /var/log/SlurmdLogFile.log 
sudo mkdir /var/spool/slurmld 
sudo chown slurm:slurm /var/spool/slurmd
sudo chmod 755 /var/spool/slurmd

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/slurm%20files/slurm.conf
sudo mv slurm.conf /etc/slurm
sudo ln -s /etc/slurm/slurm.conf /usr/local/etc/slurm.conf

sudo systemctl start slurm
sudo systemctl enable slurm
