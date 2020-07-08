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
kubectl port-forward jobs/ftpjob 21:21-$GITHUB_SHA & 
lftp -u test -p test
sleep 5
lftp cat
echo 'test'