#!/bin/sh -l
export KUBECONFIG=$GITHUB_WORKSPACE/kubeconfig
kubectl version
echo "Hello $1"
time=$(date)
echo ::set-output name=time::$time
