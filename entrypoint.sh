#!/bin/sh -l
cp -R ./kubeconfig /.kube/config
kubectl version
echo "Hello $1"
time=$(date)
echo ::set-output name=time::$time
