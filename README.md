This Action makes it easy to download any folder from a Persistent Volume (PV) on Kubernetes.

This action schedules a job to mount a PVC, then uses kubectl copy to transfer the files from the running pod to the local filesystem and finally cleans up the job.


| Parameters  | Description |
| ------------- | ------------- |
| kubeConfig  | Base64 encoded kubeConfig  |
| volume  | Persistent Volume Claim (PVC) name to download from  |
| sourcePath | Path to a folder on the Persistent Volume to download from |
| outputPath | Name of the folder to download into (the default is k8s-volume-download) |
| timeout | Timeout in seconds to wait for the job to successfully bind to the PVC |

Note: Currently very large files will fail to transfer using kubectl copy. I will be adding better support for breaking up files above a certain size into smaller chunks and reassembling them soon.
