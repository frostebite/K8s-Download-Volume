#!/bin/sh -l
sleep 10
DOWNLOAD_ID=$(cat /proc/sys/kernel/random/uuid)
DOWNLOAD_NAME=download-pv-job-$DOWNLOAD_ID

mkdir -p ~/.kube
echo $1 | base64 -d > ~/.kube/config
echo "Applied kubeConfig"

kubectl version

cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: $DOWNLOAD_NAME
  labels:
    app: k8s-download
spec:
  template:
    spec:
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: $2
      restartPolicy: Never
      containers:
      - name: download-pv
        image: alpine:latest
        command: ['/bin/sh']
        args:
          ['-c', 'sleep 140s']
        volumeMounts:
        - name: data
          mountPath: /data
EOF

sleep 5
echo "SourcePath:/data/"$3
echo "OutputPath:"$PWD/$4
kubectl wait --for=condition=ready pod -l job-name=$DOWNLOAD_NAME --timeout=$5s
kubectl exec jobs/$DOWNLOAD_NAME -- ls /data/$3
kubectl exec jobs/$DOWNLOAD_NAME -- apk update
kubectl exec jobs/$DOWNLOAD_NAME -- apk add zip
kubectl exec jobs/$DOWNLOAD_NAME -- mv /data/$3 /output
kubectl exec jobs/$DOWNLOAD_NAME -- zip -r output.zip /output
kubectl exec jobs/$DOWNLOAD_NAME -- stat output.zip
pods=$(kubectl get pods --selector=job-name=$DOWNLOAD_NAME --output=jsonpath='{.items[*].metadata.name}')
kubectl cp $pods:output.zip $PWD/output.zip
unzip $PWD/output.zip -d $PWD/$4
rm output.zip
mv $PWD/$4/output/* $PWD/$4
ls
kubectl delete jobs/$DOWNLOAD_NAME
