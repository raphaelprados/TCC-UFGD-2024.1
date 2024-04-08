#INSTALL-ALL.sh

sudo apt-get install build-essential gfortran python gdb -y
wget https://www.mpich.org/static/downloads/3.3a2/mpich-3.3a2.tar.gz
tar xf mpich-3.3a2.tar.gz
rm mpich-3.3a2.tar.gz 
cd mpich-3.3a2
sudo ./configure --with-slurm --with-pmi
sudo make
sudo make install 
cd ..
PATH=/home/manager/mpich-3.3a2/:$PATH ; export PATH

wget https://github.com/raphaelprados/TCC-2023-2/raw/main/dmtcp-2.5.2.tar.gz
tar xf dmtcp-2.5.2.tar.gz
rm dmtcp-2.5.2.tar.gz
cd dmtcp-2.5.2
sudo ./configure
sudo make
sudo make install
ssh $HOSTNAME which dmtcp_launch
ssh-keygen -t dsa
ssh-keygen -t rsa
cat ~/.ssh/id*.pub >> ~/.ssh/authorized_keys
sudo make clean
sudo make
sudo make install
cd ..

wget https://nas.nasa.gov/assets/npb/NPB3.4.2.tar.gz
tar xf NPB3.4.2.tar.gz
rm NPB3.4.2.tar.gz
cd NPB3.4.2/NPB3.4-MPI
nano config/make.def.template
make bt CLASS=E
make lu CLASS=E
make lu CLASS=C
make ft CLASS=E
cd ../..

#sudo apt-get install openssl libssl-dev libpam0g-dev numactl libnuma-dev libnuma1 hwloc libhwloc-dev lua5.3 liblua5.3-dev libreadline-dev librrd-dev libncurses5-dev man2html libibmad5 libibumad-dev -y
#wget http://134.100.28.207/files/src/slurm/slurm-21.08.3.tar.bz2
#tar xfj slurm-21.08.3.tar.bz2
#rm slurm-21.08.3.tar.bz2
#cd slurm-21.08.3
#./configure --prefix=/usr/local/slurm-21.08.3
#sudo make
#sudo make install
#cd ..
