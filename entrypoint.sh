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
        image: mikatux/ftps-server
        env:
        - name: USER
          value: test
        - name: PASSWORD
          value: test
EOF
kubectl wait --for=condition=ready pod -l job-name=ftpjob-$GITHUB_SHA --timeout=60s
kubectl port-forward jobs/ftpjob-$GITHUB_SHA 21:21 & 
sleep 5
lftp -u test,test -p 21 127.0.0.1
lftp -c ls

kubectl delete jobs/ftpjob-$GITHUB_SHA