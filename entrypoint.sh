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
      restartPolicy: Never
      containers:
      - name: ftpserver
        image: stilliard/pure-ftpd
EOF
apt-get install lftp
kubectl port-forward jobs/ftpjob 21:21 > /dev/null 2>&1 & 