FROM jupyterhub/jupyterhub:0.6.1

RUN apt-get install libmysqlclient-dev
RUN pip install oauthenticator requests mysqlclient
RUN pip install git+https://github.com/jupyterhub/dockerspawner.git@0.4.0

ADD customspawner.py /opt/conda/lib/python3.5/customspawner.py

EXPOSE 8081
