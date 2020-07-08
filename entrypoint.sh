#!/bin/sh -l
kubectl version
echo "Hello $1"
time=$(date)
echo ::set-output name=time::$time

cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: FTPJOB
spec:
  template:
    containers:
    - name: FTPServer
      image: stilliard/pure-ftpd
EOF