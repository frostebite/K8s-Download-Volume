#!/bin/sh -l
sleep 10
DOWNLOAD_ID=$(cat /proc/sys/kernel/random/uuid)
DOWNLOAD_NAME=download-pv-job-$DOWNLOAD_ID
if [[ -v $4 ]]; then
  mkdir -p ~/.kube
  echo $4 | base64 -d > ~/.kube/config
  export KUBECONFIG="~/.kube/config"
  echo 'Applied kubeConfig'
fi

kubectl version

cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: $DOWNLOAD_NAME
spec:
  template:
    spec:
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: $1
      restartPolicy: Never
      containers:
      - name: download-pv
        image: nginx:latest
        volumeMounts:
        - name: data
          mountPath: /data
EOF

sleep 5
kubectl wait --for=condition=ready pod -l job-name=$DOWNLOAD_NAME --timeout=$3s
kubectl exec jobs/$DOWNLOAD_NAME -- ls /data/$2
kubectl exec jobs/$DOWNLOAD_NAME -- apt-get update
kubectl exec jobs/$DOWNLOAD_NAME -- apt-get install zip unzip
kubectl exec jobs/$DOWNLOAD_NAME -- zip -r /output.zip /data/$2
kubectl exec jobs/$DOWNLOAD_NAME -- stat /output.zip
pods=$(kubectl get pods --selector=job-name=$DOWNLOAD_NAME --output=jsonpath='{.items[*].metadata.name}')
kubectl describe pod $pods
kubectl cp $pods:output.zip $PWD/output.zip
unzip $PWD/output.zip -d $PWD
ls
kubectl delete jobs/$DOWNLOAD_NAME
