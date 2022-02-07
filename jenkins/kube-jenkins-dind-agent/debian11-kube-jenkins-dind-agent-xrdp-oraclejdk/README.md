# Jenkins Docker-in-Docker Agent

A simple Docker image for running a Jenkins agent alongside its very
own Docker daemon. This is useful if you're trying to run Jenkins agents on a
Kubernetes cluster, and you also want to build and push Docker images using your
CI system.

features
1. docker in dokcer
2. jnlp with java
3. kubectl
4. git

plugins


## Usage
### Command line
Try it out locally by running the following command:

```bash
docker run slpcat/kube-jenkins-dind-agent -url http://jenkins-server:port -workDir=/home/jenkins/agent <secret> <agent name>
```

### Jenkins
You'll need to configure the kubernetes plugin on your Jenkins master to use this
image. You'll probably also want to give it a special slave label, so that you
don't unnecessarily run builds using the dind image.

[docker-hub]: https://hub.docker.com/r/slpcat/kube-jenkins-dind-agent
