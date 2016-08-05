import shutil
from traitlets import Unicode

from dockerspawner import DockerSpawner


class CustomSpawner(DockerSpawner):

    container_ip = '0.0.0.0'

    @gen.coroutine
    def lookup_node_name(self):
        """Find the name of the swarm node that the container is running on."""
        containers = yield self.docker('containers', all=True)
        for container in containers:
            if container['Id'] == self.container_id:
                name, = container['Names']
                node, container_name = name.lstrip("/").split("/")
                raise gen.Return(node)

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
        # look up mapping of node names to ip addresses
        info = yield self.docker('info')
        for i in info:
            self.log.info(i)
        num_nodes = int(info['DriverStatus'][3][1])
        node_info = info['DriverStatus'][4::5]
        self.node_info = {}
        for i in range(num_nodes):
            node, ip_port = node_info[i]
            self.node_info[node] = ip_port.split(":")[0]
        self.log.debug("Swarm nodes are: {}".format(self.node_info))

        # create user home directory
        self.create_home_dir()

        # start the container
        super(CustomSpawner, self).start(*args, **kwargs)

        # figure out what the node is and then get its ip
        name = yield self.lookup_node_name()
        self.user.server.ip = self.node_info[name]
        self.log.info("{} was started on {} ({}:{})".format(
            self.container_name, name, self.user.server.ip, self.user.server.port))
