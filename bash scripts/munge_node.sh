wget https://github.com/raphaelprados/TCC-UFGD-2024.1/raw/main/bash%20scripts/install.sh

sudo apt install munge libmunge2 libmunge-dev
sudo mv munge.key /etc/munge
sudo chown -R munge: /etc/munge/ /var/log/munge/ /var/lib/munge/ /run/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/ /var/lib/munge/
sudo chmod 0755 /run/munge/
sudo chmod 0700 /etc/munge/munge.key
sudo chown -R munge: /etc/munge/munge.key