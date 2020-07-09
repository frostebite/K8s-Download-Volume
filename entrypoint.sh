#!/bin/sh -l
kubectl version

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
kubectl port-forward jobs/ftpjob-$GITHUB_SHA 21:21 & 
sleep 5
sftp test:test@127.0.0.1