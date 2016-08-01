# jupyterhub_config.py
c = get_config()

import os
pjoin = os.path.join

runtime_dir = os.path.join('/srv/jupyterhub')
ssl_dir = pjoin(runtime_dir, 'ssl')
if not os.path.exists(ssl_dir):
    os.makedirs(ssl_dir)


# https on :443
c.JupyterHub.port = 8000
# c.JupyterHub.ssl_key = pjoin(ssl_dir, 'ssl.key')
# c.JupyterHub.ssl_cert = pjoin(ssl_dir, 'ssl.pem')

# put the JupyterHub cookie secret and state db
# in /srv/jupyterhub/
# c.JupyterHub.cookie_secret_file = pjoin(runtime_dir, 'cookie_secret')
c.JupyterHub.db_url = pjoin(runtime_dir, 'jupyterhub.sqlite')
# or `--db=/path/to/jupyterhub.sqlite` on the command-line

# use GitHub OAuthenticator for local users

c.JupyterHub.authenticator_class = 'oauthenticator.LocalGitHubOAuthenticator'
c.GitHubOAuthenticator.oauth_callback_url = 'https://dev.jupyter.informaticslab.co.uk/hub/oauth_callback'
# create system users that don't exist yet
c.LocalAuthenticator.create_system_users = True

# specify users and admin
c.Authenticator.whitelist = {'niallrobinson'}
c.Authenticator.admin_users = {'niallrobinson'}

# start single-user notebook servers in ~/assignments,
# with ~/assignments/Welcome.ipynb as the default landing page
# this config could also be put in
# /etc/ipython/ipython_notebook_config.py


c.Examples.reviewed_example_dir = '/usr/share/jupyter/notebooks/reviewed'
c.Examples.unreviewed_example_dir = '/usr/share/jupyter/notebooks/unreviewed'
