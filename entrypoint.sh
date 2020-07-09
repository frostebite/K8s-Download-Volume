#!/bin/sh -l
kubectl version
echo $1
echo $2
echo $3
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
        image: nginx:latest
EOF
kubectl wait --for=condition=ready pod -l job-name=ftpjob-$GITHUB_SHA --timeout=60s
kubectl exec jobs/ftpjob-$GITHUB_SHA -- ls
kubectl delete jobs/ftpjob-$GITHUB_SHA