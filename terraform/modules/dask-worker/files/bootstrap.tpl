#!/bin/bash
echo "Start at:" $(date)
apt-get update -y
apt-get upgrade -y
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
wget http://repo.continuum.io/miniconda/Miniconda3-3.7.0-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda
export PATH="$HOME/miniconda/bin:/miniconda/bin:$PATH"
echo "export PATH=\"$HOME/miniconda/bin:/miniconda/bin:$PATH\"" >> ~/.bashrc
conda update --yes conda
# TODO: fix dask and distrabuted versions
conda install dask distributed -c conda-forge --yes
conda install -c conda-forge iris --yes
conda install -c anaconda boto3 --yes

echo "Every thing installed ok at: " $(date)
date
if grep -q amazon /sys/devices/virtual/dmi/id/bios_version; then
    echo "I'm an amazon server"
	dask-worker ${scheduler_address}:8786 --nprocs $(grep -c ^processor /proc/cpuinfo) --nthreads 1  --host $(wget -qO- http://instance-data/latest/meta-data/public-ipv4) 
else
    echo "I'm alibaba server"
	dask-worker ${scheduler_address}:8786 --nprocs $(grep -c ^processor /proc/cpuinfo) --nthreads 1 --host $(wget -qO- http://100.100.100.200/latest/meta-data/eipv4) 
fi