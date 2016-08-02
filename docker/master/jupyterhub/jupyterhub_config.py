# jupyterhub_config.py
c = get_config()

import os
pjoin = os.path.join

runtime_dir = os.path.join('/srv/jupyterhub')

ssl_dir = '/usr/local/share/certs/'

c.JupyterHub.port = 8000
c.JupyterHub.ssl_key = pjoin(ssl_dir, 'key.pem')
c.JupyterHub.ssl_cert = pjoin(ssl_dir, 'cert.pem')

c.JupyterHub.db_url = pjoin(runtime_dir, 'jupyterhub.sqlite')

# use GitHub OAuthenticator for local users
c.JupyterHub.authenticator_class = 'oauthenticator.LocalGitHubOAuthenticator'
c.GitHubOAuthenticator.oauth_callback_url = 'https://dev.jupyter.informaticslab.co.uk/hub/oauth_callback'

# create system users that don't exist yet
c.LocalAuthenticator.create_system_users = True

# specify users and admin
c.Authenticator.whitelist = {'niallrobinson'}
c.Authenticator.admin_users = {'niallrobinson'}