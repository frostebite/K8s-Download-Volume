#!/bin/sh -l
kubectl version
echo "Hello $1"
time=$(date)
echo ::set-output name=time::$time

cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: ftpjob
spec:
  template:
    spec:
      containers:
      - name: ftpserver
        image: stilliard/pure-ftpd
EOF