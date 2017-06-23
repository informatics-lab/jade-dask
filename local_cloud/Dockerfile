FROM ubuntu
RUN apt-get update
RUN apt-get upgrade
RUN apt-get install wget bzip2 -y
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN wget http://repo.continuum.io/miniconda/Miniconda3-3.7.0-Linux-x86_64.sh -O ~/miniconda.sh
RUN bash ~/miniconda.sh -b -p $HOME/miniconda
ENV PATH="$HOME/miniconda/bin:/miniconda/bin:$PATH"
RUN echo "export PATH=\"$HOME/miniconda/bin:/miniconda/bin:$PATH\"" >> ~/.bashrc
RUN echo $PATH

RUN ls /root/miniconda/bin
RUN /root/miniconda/bin/conda update --yes conda
RUN /root/miniconda/bin/conda install dask distributed -c conda-forge --yes
RUN /root/miniconda/bin/conda install -c conda-forge iris --yes
RUN /root/miniconda/bin/conda install -c anaconda boto3 --yes
CMD /root/miniconda/bin/dask-worker $SCD_ADDR:8786  --host $MY_IP --worker-port=8777 --http-port=8778 --nanny-port=8779
EXPOSE 8777 8778 8779
