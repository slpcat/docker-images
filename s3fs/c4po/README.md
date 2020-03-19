# Run a SFTP server with AWS S3 storage in Kubernetes




## Run in Kubernetes
```
export AWS_ACCESS_KEY_ID=xxxxx
export AWS_SECRET_ACCESS_KEY=xxxx
export SFTP_USER=admin
export SFTP_PASSWORD=password
export SSH_KEY=~/.ssh/id_rsa.pub
export S3_BUCKET=mybucket
export S3_KEY=/
make
```

details http://blog.bonesoul.com/sftp-s3-kubernetes/