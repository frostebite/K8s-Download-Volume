#!/bin/sh -l
kubectl get ns
echo "Hello $1"
time=$(date)
echo ::set-output name=time::$time
