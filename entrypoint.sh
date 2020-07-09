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
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: $1
      restartPolicy: Never
      containers:
      - name: ftpserver
        image: nginx:latest
        volumeMounts:
        - name: data
          mountPath: /data
EOF
kubectl wait --for=condition=ready pod -l job-name=ftpjob-$GITHUB_SHA --timeout=60s
kubectl exec jobs/ftpjob-$GITHUB_SHA -- ls /data/repo
kubectl delete jobs/ftpjob-$GITHUB_SHA