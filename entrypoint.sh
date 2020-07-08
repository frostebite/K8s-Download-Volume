#!/bin/sh -l

kubectl version
echo "Hello $1"
time=$(date)
echo ::set-output name=time::$time
