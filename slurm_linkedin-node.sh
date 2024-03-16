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
