FROM debian:8.5

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean   

ENV PATH /opt/conda/bin:$PATH

RUN conda update -y conda

WORKDIR /root

RUN conda install -y -c scitools scipy boto iris cartopy jupyter
# RUN conda install -y -c conda-forge PySide 
# RUN pip install git+https://github.com/met-office-lab/SHARPpy.git@remove_su_check

RUN jupyter notebook --generate-config
ADD jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

RUN mkdir -p /usr/local/share/notebooks
WORKDIR /usr/local/share/notebooks

EXPOSE 8888
ENTRYPOINT ["tini", "--"]
CMD ["jupyter", "notebook"]