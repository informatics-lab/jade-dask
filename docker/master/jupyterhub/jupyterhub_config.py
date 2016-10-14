# jupyterhub_config.py
c = get_config()

import os
import requests

# serve the jub to everyone on port 8000
c.JupyterHub.port = 8000
c.JupyterHub.hub_ip = '0.0.0.0'

# store the sqlite database on persistant storage
c.JupyterHub.db_url = "mysql://{}:{}@mysql/jupyter".format("root", os.environ['MYSQL_ROOT_PASSWORD'])

# use GitHub OAuthenticator for local users
c.JupyterHub.authenticator_class = 'oauthenticator.LocalGitHubOAuthenticator'
c.GitHubOAuthenticator.oauth_callback_url = os.environ['OAUTH_CALLBACK_URL']

# create system users that don't exist yet
c.LocalAuthenticator.create_system_users = True

c.JupyterHub.spawner_class = 'customspawner.CustomSpawner'
# Spawn user containers from this image
c.DockerSpawner.container_image = 'quay.io/informaticslab/asn-serve'
c.DockerSpawner.volumes = {'/mnt/jade-notebooks/home/{username}': '/usr/local/share/notebooks'}
c.DockerSpawner.read_only_volumes = {'/mnt/jade-notebooks/data': '/data'}
c.DockerSpawner.hub_ip_connect = requests.get("http://169.254.169.254/latest/meta-data/local-ipv4").text
c.DockerSpawner.remove_containers = True

# Custom logo
c.JupyterHub.logo_file = '/root/logo.png'
