FROM debian:8.5

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get clean && apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
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

RUN apt-get install -y make cmake

# Python 3.4
RUN conda create --name py34 -y python=3.4
RUN apt-get install -y build-essential git cmake libqt4-dev libphonon-dev python2.7-dev libxml2-dev libxslt1-dev qtmobility-dev libqtwebkit-dev
RUN bash -c "source activate py34 && \
             conda install -y scipy boto jupyter"
RUN bash -c "source activate py34 && \
             conda install -y -c scitools iris cartopy"


# RUN bash -c "source activate py34 && \
#              git clone https://github.com/PySide/pyside-setup.git pyside-setup && \
#              cd pyside-setup && \
#              python setup.py bdist_wheel --qmake=/usr/bin/qmake-qt4 --version=1.2.4 && \
#              cd .. && \
#              rm -rf ./pyside-setup
RUN bash -c "source activate py34 && \
             pip install jupyter_dashboards && jupyter dashboards quick-setup --sys-prefix"

# Python 2
RUN conda create -y -n py2 python=2 ipykernel
RUN bash -c "source activate py2 && \
             conda install -y scipy boto jupyter"
RUN bash -c "source activate py2 && \
             conda install -y -c scitools iris cartopy"
RUN bash -c "source activate py2 && python -m ipykernel install --user"

#Clojure
RUN update-ca-certificates -f
RUN curl -k https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > /usr/local/bin/lein
RUN chmod +x /usr/local/bin/lein
RUN apt-get install -y default-jre
RUN git clone https://github.com/roryk/clojupyter
RUN mkdir -p /etc/pki/tls/certs && ln -s /etc/ssl/certs/ca-certificates.crt /etc/pki/tls/certs/ca-bundle.crt
RUN cd clojupyter && make && make install && cd .. && rm -rf clojupyter

# R
RUN conda install -y -n py34 -c r r-essentials

# Setup the JupyterHub single user entrypoint
RUN bash -c "source activate py34 && \
             pip --no-cache-dir install 'jupyterhub==0.5'"

RUN wget -q https://raw.githubusercontent.com/jupyter/jupyterhub/master/scripts/jupyterhub-singleuser -O /usr/local/bin/jupyterhub-singleuser && \
    chmod 755 /usr/local/bin/jupyterhub-singleuser && \
    mkdir -p /srv/singleuser/
ADD start-singleuser.sh /srv/singleuser/singleuser.sh 
RUN chmod 755 /srv/singleuser/singleuser.sh

RUN bash -c "source activate py34 && \
             jupyter notebook --generate-config"
ADD jupyter_notebook_config.py /root/.jupyter/

RUN mkdir -p /usr/local/share/notebooks
WORKDIR /usr/local/share/notebooks

# Scala
RUN bash -c "source activate py34 && \
             curl -L -o jupyter-scala https://git.io/vrHhi && \
             chmod +x jupyter-scala && \
             ./jupyter-scala && rm -f jupyter-scala"

# NB Extensions
RUN bash -c "source activate py34 && \
                conda install -y -c conda-forge jupyter_nbextensions_configurator"

RUN echo "#!/usr/bin/env python3\nfrom jupyterhub.singleuser import main\nimport logging\nif __name__ == '__main__':\n    logging.basicConfig(level=logging.DEBUG)\n    main()" > /usr/local/bin/jupyterhub-singleuser

EXPOSE 8888
ENTRYPOINT ["tini", "--"]
CMD bash -c "source activate py34 && \
             /srv/singleuser/singleuser.sh"
