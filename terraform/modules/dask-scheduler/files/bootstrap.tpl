#!/bin/bash
apt-get update
apt-get upgrade
wget http://repo.continuum.io/miniconda/Miniconda3-3.7.0-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda
export PATH="$HOME/miniconda/bin:/miniconda/bin:$PATH"
echo "export PATH=\"$HOME/miniconda/bin:/miniconda/bin:$PATH\"" >> ~/.bashrc
conda update --yes conda
conda install dask distributed -c conda-forge --yes
conda install -c conda-forge iris --yes
dask-scheduler --port 8786 --bokeh-port 8787