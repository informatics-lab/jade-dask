import logging
import os

from distributed.deploy import Adaptive
from kubernetes import client, config
from kubernetes.client.rest import ApiException


logger = logging.getLogger("distributed.deploy.adaptive")


class KubeCluster(object):
    def __init__(self, **kwargs):
        config.load_incluster_config()
        self.api_instance = client.ExtensionsV1beta1Api()
        self.namespace = 'dask'
        self.deployment = 'dask-workers'
        logger.info("Initialising kubernetes scaler")

    def scale_up(self, n):
        """
        Bring the total count of workers up to ``n``

        This function/coroutine should bring the total number of workers up to
        the number ``n``.

        This can be implemented either as a function or as a Tornado coroutine.
        """
        logger.info("Scaling up")
        current_deployment = self.api_instance.read_namespaced_deployments_scale(self.deployment, self.namespace)
        logger.info("Current number of workers is %s", current_deployment.spec.replicas)
        current_deployment.spec.replicas = n
        logger.info("Scaling to %s", current_deployment.spec.replicas)
        try:
            self.api_instance.replace_namespaced_deployments_scale(
                self.deployment, self.namespace, current_deployment)
        except ApiException as e:
            logger.error("Exception when scaling up {}: {}".format(self.deployment, e))

    def scale_down(self, workers):
        """
        Remove ``workers`` from the cluster

        Given a list of worker addresses this function should remove those
        workers from the cluster.  This may require tracking which jobs are
        associated to which worker address.

        This can be implemented either as a function or as a Tornado coroutine.
        """
        logger.info("Scaling down")
        if workers:
            current_deployment = self.api_instance.read_namespaced_deployments_scale(self.deployment, self.namespace)
            if current_deployment.spec.replicas is None:
                current_deployment.spec.replicas = 0
            logger.info("Current number of workers is %s", current_deployment.spec.replicas)
            current_deployment.spec.replicas = current_deployment.spec.replicas - len(workers)
            logger.info("Scaling to %s", current_deployment.spec.replicas)
            try:
                self.api_instance.replace_namespaced_deployments_scale(
                    self.deployment, self.namespace, current_deployment)
            except ApiException as e:
                logger.error("Exception when scaling up {}: {}".format(self.deployment, e))
        else:
            logger.info("Nothing to do")


def dask_setup(scheduler):
    cluster = KubeCluster()
    adapative_cluster = Adaptive(scheduler, cluster)
