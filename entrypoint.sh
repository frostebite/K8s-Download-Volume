#!/bin/sh -l

mkdir /.kube
cp -R $GITHUB_WORKSPACE/kubeconfig /.kube/config
kubectl version
echo "Hello $1"
time=$(date)
echo ::set-output name=time::$time
