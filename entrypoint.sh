#!/bin/sh -l
ls $GITHUB_WORKSPACE
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
cp ./kubeconfig $HOME/.kube/config
./kubectl version
echo "Hello $1"
time=$(date)
echo ::set-output name=time::$time
