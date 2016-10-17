FROM jupyterhub/jupyterhub:0.6.1

RUN apt-get update && apt-get install -y libmysqlclient-dev
RUN pip install oauthenticator requests mysqlclient
RUN pip install git+https://github.com/jupyterhub/dockerspawner.git@0.4.0

ADD customspawner.py /opt/conda/lib/python3.5/customspawner.py
# Custom logo and css
ADD logo.png /root/logo.png
ADD custom.css /root/custom.css
RUN cat /root/custom.css >> /opt/conda/share/jupyter/hub/static/css/style.min.css  && rm -f /root/custom.css
ADD favicon.ico /opt/conda/share/jupyter/hub/static/favicon.ico


EXPOSE 8081
