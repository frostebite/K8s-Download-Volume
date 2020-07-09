#!/bin/sh -l
kubectl version
sleep 10
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

if [[ -v $3 ]]; then
  echo $3
fi
sleep 5
kubectl wait --for=condition=ready pod -l job-name=ftpjob-$GITHUB_SHA --timeout=60s
kubectl exec jobs/ftpjob-$GITHUB_SHA -- ls /data/repo
kubectl exec jobs/ftpjob-$GITHUB_SHA -- apt-get update
kubectl exec jobs/ftpjob-$GITHUB_SHA -- apt-get install zip unzip
kubectl exec jobs/ftpjob-$GITHUB_SHA -- zip -r /output.zip /data/$2
kubectl exec jobs/ftpjob-$GITHUB_SHA -- stat /output.zip
pods=$(kubectl get pods --selector=job-name=ftpjob-$GITHUB_SHA --output=jsonpath='{.items[*].metadata.name}')
kubectl get pod $pods
kubectl cp $pods:output.zip $PWD/output.zip
ls
kubectl delete jobs/ftpjob-$GITHUB_SHA
