FROM jupyterhub/jupyterhub

RUN pip install oauthenticator requests
RUN pip install git+https://github.com/jupyterhub/dockerspawner.git@0.4.0

ADD customspawner.py /opt/conda/lib/python3.5/customspawner.py

EXPOSE 8081
