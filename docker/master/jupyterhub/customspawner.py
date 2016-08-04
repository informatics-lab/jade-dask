import os
import shutil
from traitlets import Unicode

from dockerspawner import DockerSpawner


class CustomSpawner(DockerSpawner):\

    home_path_template = Unicode(
        '/mnt/jade-notebooks/home/{username}',
        config=True,
        help='Template to expand to set the user home. {username} is expanded'
    )

    @property
    def home_path(self):
        return self.home_path_template.format(
            username=self.user.name
        )

    def make_preexec_fn(self, name):
        home = self.home_path
        def preexec():
            try:
                os.makedirs(home, 0o755, exist_ok=True)
                shutil.copytree('/mnt/jade-notebooks/home/skel', home)
            except e:
                print(e)
        return preexec
