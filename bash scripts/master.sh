
sudo apt update
sudo apt upgrade

sudo apt install munge libmunge2 libmunge-dev
sudo chown -R munge: /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/ /var/lib/munge/
sudo chmod 0755 /run/munge/
sudo chmod 0700 /etc/munge/munge.key
sudo chown -R munge: /etc/munge/munge.key

sudo systemctl enable munge
sudo systemctl restart munge

sudo -i
scp /etc/munge/munge.key manager@192.168.1.$node1:~
scp /etc/munge/munge.key manager@192.168.1.$node2:~
exit

read -n 1 -p "Aguarde a instalacao do Munge nos nodes.."

sudo apt install slurm-wlm
wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/slurm%20files/slurm.conf
sudo mv slurm.conf /etc/slurm-llnl/
sudo systemctl enable slurmctld
sudo systemctl restart slurmctld

sudo -i
scp /etc/slurm-llnl/slurm.conf manager@192.168.1.$node1:~
scp /etc/slurm-llnl/slurm.conf manager@192.168.1.$node2:~
exit

read -n 1 -p "Aguarde a instalacao do Slurm nos nodes.."

wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/bash%20scripts/install.sh
chmod +x install.sh
./install.sh
