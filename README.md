This Action makes it easy to download any folder from a Persistent Volume Claim (PVC) on Kubernetes.

This action schedules a job to mount the PVC, then uses kubectl copy to transfer the files from the running pod to the local filesystem and finally cleans up the job.

Parameters:

kubeConfig - Base64 encoded kubeConfig.

volume - Persistent Volume Claim (PVC) name to download from

sourcePath - Path to download from on the PVC

timeout - Timeout in seconds to wait for the job to successfully bind to the PVC


Note:

Currently very large files will fail to transfer using kubectl copy. I will be adding better support for this shortly.
