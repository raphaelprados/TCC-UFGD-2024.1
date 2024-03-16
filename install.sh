#INSTALL-ALL.sh

sudo apt-get install build-essential gfortran pthon gdb -y
wget https://www.mpich.org/static/downloads/3.3a2/mpich-3.3a2.tar.gz
tar xf mpich-3.3a2.tar.gz
rm mpich-3.3a2.tar.gz 
cd mpich-3.3a2
sudo ./configure --with-slurm
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
ssh cnode which dmtcp_launch
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


