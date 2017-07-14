from distributed.deploy import Adaptive
# from kubernetes import client, config
from tornado import gen


class MyCluster(object):
    def scale_up(self, n):
        """
        Bring the total count of workers up to ``n``

        This function/coroutine should bring the total number of workers up to
        the number ``n``.

        This can be implemented either as a function or as a Tornado coroutine.
        """
        pass


    def scale_down(self, workers):
        """
        Remove ``workers`` from the cluster

        Given a list of worker addresses this function should remove those
        workers from the cluster.  This may require tracking which jobs are
        associated to which worker address.

        This can be implemented either as a function or as a Tornado coroutine.
        """
        pass


def dask_setup(scheduler):
    cluster = MyCluster()
    # adapative_cluster = Adaptive(scheduler, cluster)
