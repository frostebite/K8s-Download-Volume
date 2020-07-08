#!/bin/sh -l
kubectl version
echo "Hello $1"
time=$(date)
echo ::set-output name=time::$time

cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: ftpjob-$GITHUB_SHA
spec:
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: ftpserver
        image: stilliard/pure-ftpd
        env:
        - name: FTP_USER_NAME
          value: test
        - name: FTP_USER_PASS
          value: test
EOF
kubectl wait --for=condition=ready pod -l job-name=ftpjob-$GITHUB_SHA --timeout=60s
kubectl port-forward --address localhost jobs/ftpjob-$GITHUB_SHA 21:21 & 
lftp ftp://test:test@localhost
lftp -c put kubeconfig
lftp -c ls