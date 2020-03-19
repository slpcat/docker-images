# dcos-gitlab-runner-service

[![Build Status](https://jenkins.mesosphere.com/service/jenkins/buildStatus/icon?job=GitLab/dcos-gitlab-runner-service-publish-docker_release)](https://jenkins.mesosphere.com/service/jenkins/job/GitLab/job/dcos-gitlab-runner-service-publish-docker_release/)
[![Docker Stars](https://img.shields.io/docker/stars/mesosphere/dcos-gitlab-runner-service.svg)](https://hub.docker.com/r/mesosphere/dcos-gitlab-runner-service/)
[![Docker Pulls](https://img.shields.io/docker/pulls/mesosphere/dcos-gitlab-runner-service.svg)](https://hub.docker.com/r/mesosphere/dcos-gitlab-runner-service/)
[![](https://images.microbadger.com/badges/image/mesosphere/dcos-gitlab-runner-service.svg)](http://microbadger.com/images/mesosphere/dcos-gitlab-runner-service "Get your own image badge on microbadger.com")

A customized Docker image for running scalable GitLab CI runners on DC/OS via Marathon.

## Configuration

The GitLab runner can be configured by environment variables. For a complete overview, have a look at the [docs/gitlab_runner_register_arguments.md](docs/gitlab_runner_register_arguments.md) file.

The most important ones are:

* `GITLAB_SERVICE_NAME`: The Mesos DNS service name of the GitLab instance, e.g. `gitlab.marathon.mesos`. This strongly depends on your setup, i.e. how you launched GitLab and how you configured Mesos DNS. This is the recommended method to use with DC/OS installations of GitLab. Either this environment variable or `GITLAB_INSTANCE_URL` is **mandatory**.
* `GITLAB_INSTANCE_URL`: The URL of the GitLab instance to connect to, e.g. `http://gitlab.mycompany.com`. Either this environment variable or `GITLAB_SERVICE_NAME` is **mandatory**.
* `REGISTRATION_TOKEN`: The registration token to use with the GitLab instance. See the [docs](https://docs.gitlab.com/ce/ci/runners/README.html) for details. **(mandatory)**
* `RUNNER_EXECUTOR`: The type of the executor to use, e.g. `shell` or `docker`. See the [executor docs](https://github.com/ayufan/gitlab-ci-multi-runner/blob/master/docs/executors/README.md) for more details. **(mandatory)**
* `RUNNER_CONCURRENT_BUILDS`: The number of concurrent builds this runner should be able to handel. Default is `1`.
* `RUNNER_TAG_LIST`: If you want to use tags in you `.gitlab-ci.yml`, then you need to specify the comma-separated list of tags. This is useful to distinguish the runner types.

## Using private Docker registries with GitLab Runner

Private Docker registries can be used by adding the [secret variable](https://docs.gitlab.com/ce/ci/variables/#secret-variables) `DOCKER_AUTH_CONFIG` to your project's **Settings ➔ CI/CD Pipelines** settings. Have a look at the [guide](https://docs.gitlab.com/runner/configuration/advanced-configuration.html#using-a-private-container-registry) as well.

## Run on DC/OS

This version of the GitLab CI runner for Marathon project uses Docker-in-Docker techniques, with all of its pros and cons. See also [jpetazzo's article](http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/) on this topic.

In the following examples, we assume that you're running the GitLab Universe package as service `gitlab` on the DC/OS internal Marathon instance, which is also available to the runners via the `external_url` of the GitLab configuration. This normally means that GitLab is exposed on a public agent node via marathon-lb. Please see the [example documentation here|https://github.com/dcos/examples/tree/master/1.8/gitlab].

### Shell runner

An example for a shell runner. This enables the build of Docker images.

```javascript
{
  "id": "gitlab-runner-shell",
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "mesosphere/dcos-gitlab-runner-service:v9.1.1",
      "network": "HOST",
      "forcePullImage": true,
      "privileged": true
    }
  },
  "instances": 1,
  "cpus": 1,
  "mem": 2048,
  "env": {
    "GITLAB_SERVICE_NAME": "gitlab.marathon.mesos",
    "REGISTRATION_TOKEN": "zzNWmRE--SBfeMfiKCMh",
    "RUNNER_EXECUTOR": "shell",
    "RUNNER_TAG_LIST": "shell,build-as-docker",
    "RUNNER_CONCURRENT_BUILDS": "4"
  },
  "taskKillGracePeriodSeconds": 15,
  "healthChecks": [
     {
       "path": "/metrics",
       "portIndex": 0,
       "protocol": "HTTP",
       "gracePeriodSeconds": 300,
       "intervalSeconds": 60,
       "timeoutSeconds": 20,
       "maxConsecutiveFailures": 3,
       "ignoreHttp1xx": false
     }
  ]
}
``` 

### Docker runner

Here's an example for a Docker runner, which enables builds *inside* Docker containers:

```javascript
{
  "id": "gitlab-runner-docker",
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "mesosphere/dcos-gitlab-runner-service:v9.1.1",
      "network": "HOST",
      "forcePullImage": true,
      "privileged": true
    }
  },
  "instances": 1,
  "cpus": 1,
  "mem": 2048,
  "env": {
    "GITLAB_SERVICE_NAME": "gitlab.marathon.mesos",
    "REGISTRATION_TOKEN": "zzNWmRE--SBfeMfiKCMh",
    "RUNNER_EXECUTOR": "docker",
    "RUNNER_TAG_LIST": "docker,build-in-docker",
    "RUNNER_CONCURRENT_BUILDS": "4",
    "DOCKER_IMAGE": "node:6-wheezy"
  },
  "taskKillGracePeriodSeconds": 15,
  "healthChecks": [
     {
        "path": "/metrics",
        "portIndex": 0,
        "protocol": "HTTP",
        "gracePeriodSeconds": 300,
        "intervalSeconds": 60,
        "timeoutSeconds": 20,
        "maxConsecutiveFailures": 3,
        "ignoreHttp1xx": false
      }
  ]
}
```

Make sure you choose a useful default Docker image via `DOCKER_IMAGE`, for example if you want to build Node.js projects, the `node:6-wheezy` image. This can be overwritten with the `image` property in the `.gitlab-ci.yml` file (see the [GitLab CI docs](https://docs.gitlab.com/ce/ci/yaml/README.html).

## Usage in GitLab CI

### Builds as Docker

An `.gitlab-ci.yml` example of using the `build-as-docker` tag to trigger a build on the runner(s) with shell executors:

```yaml
stages:
  - ci

build-job:
  stage: ci
  tags:
    - build-as-docker
  script:
    - docker build -t tobilg/test .
```

This assumes your project has a `Dockerfile`, for example

```
FROM nginx
```

### Builds in Docker

An `.gitlab-ci.yml` example of using the `build-in-docker` tag to trigger a build on the runner(s) with Docker executors:

```yaml
image: node:6-wheezy

stages:
  - ci

test-job:
  stage: ci
  tags:
    - build-in-docker
  script:
    - node --version
```