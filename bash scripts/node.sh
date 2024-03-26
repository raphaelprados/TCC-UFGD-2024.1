

sudo apt update
sudo apt upgrade

sudo apt install munge libmunge2 libmunge-dev
sudo mv munge.key /etc/munge
sudo chown -R munge: /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/ /var/lib/munge/
sudo chmod 0755 /run/munge/
sudo chmod 0700 /etc/munge/munge.key
sudo chown -R munge: /etc/munge/munge.key

sudo systemctl enable munge
sudo systemctl restart munge

sudo apt install slurm-wlm
sudo mv slurm.conf /etc/slurm-llnl/

sudo systemctl enable slurmd
sudo systemctl restart slurmd

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/bash%20scripts/install.sh
chmod +x install.sh
./install.sh
