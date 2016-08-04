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

    def create_home_dir(self):
        try:
            self.log.debug("Copying skel to home/{}".format(self.user.name))
            shutil.copytree('/mnt/jade-notebooks/home/skel', self.home_path)
        except Exception as e:
            self.log.error(e)

    def start(self, *args, **kwargs):
        self.create_home_dir()
        return super(CustomSpawner, self).start(*args, **kwargs)
