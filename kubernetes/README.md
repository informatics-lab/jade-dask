```shell
kubectl create -f namespace.yaml
kubectl create configmap scheduler --from-file=adaptive.py --from-file=run.sh  --namespace=dask
kubectl create -f deployment.yaml
kubectl create -f service.yaml
kubectl create -f ingress.yaml
```
