# Jenkins on Kubernetes

Run a Jenkins master on Kubernetes, using Docker. This Jenkins instance is pre-configured to autoscale build agents onto the Kubernetes cluster using the [Jenkins kubernetes plugin][kubernetes-plugin].

## Overview
This repo contains a [Dockerfile](Dockerfile) that runs Jenkins inside a Docker
container. It also provides several Jenkins plugins and a basic Jenkins configuration in order to get you
up and running quickly with Jenkins on Kubernetes.

## Reporting issues


## Included in this repo
Base packages:
  * [Jenkins][jenkins-home] 2.89.2 (LTS)

Jenkins plugins:
  blueocean-commons
  blueocean-config
  blueocean-dashboard
  blueocean-display-url
  blueocean-events
  blueocean-git-pipeline
  blueocean-github-pipeline
  blueocean-i18n
  blueocean-jwt
  blueocean-personalization
  blueocean-pipeline-api-impl
  blueocean-pipeline-editor
  blueocean-pipeline-scm-api
  blueocean-rest-impl
  blueocean-rest
  blueocean-web
  blueocean
  android-emulator
  android-lint
  ant
  ace-editor
  analysis-core
  ansible
  ansicolor
  antisamy-markup-formatter
  artifactory
  audit-trail
  authentication-tokens
  azure-credentials
  azure-vm-agents
  branch-api
  build-failure-analyzer
  build-name-setter
  build-pipeline-plugin
  build-timeout
  build-token-root
  cloudbees-folder
  cloverphp
  conditional-buildstep
  config-file-provider
  copy-to-slave
  copyartifact
  cvs
  dashboard-view
  delivery-pipeline-plugin
  description-setter
  dingding-notifications
  docker-build-publish
  docker-workflow
  durable-task
  ec2
  email-ext
  embeddable-build-status
  envinject
  extended-read-permission
  external-monitor-job
  favorite
  ghprb
  git
  git-client
  git-server
  github
  github-api
  github-organization-folder
  gitlab
  gitlab-hook
  gitlab-oauth
  gradle
  greenballs
  handlebars
  ivy
  jackson2-api
  jenkins-multijob-plugin
  job-dsl
  jobConfigHistory
  jquery
  kpp-management-plugin
  kubernetes
  kubernetes-ci
  kubernetes-cd
  kubernetes-pipeline-steps
  ldap
  mapdb-api
  marathon
  matrix-auth
  matrix-project
  maven-plugin
  mesos
  metrics
  momentjs
  monitoring
  msbuild
  nant
  node-iterator-api
  pam-auth
  parameterized-trigger
  pipeline-build-step
  pipeline-github-lib
  pipeline-input-step
  pipeline-milestone-step
  pipeline-model-api
  pipeline-model-definition
  pipeline-model-extensions
  pipeline-rest-api
  pipeline-stage-step
  pipeline-stage-view
  plain-credentials
  postbuildscript
  publish-over-cifs
  publish-over-ftp
  publish-over-ssh
  puppet
  rebuild
  role-strategy
  run-condition
  s3
  saferestart
  saml
  saltstack
  scm-api
  ssh-agent
  ssh-slaves
  slave-setup
  subversion
  timestamper
  translation
  uno-choice
  variant
  view-job-filters
  windows-slaves
  workflow-aggregator
  workflow-api
  workflow-basic-steps
  workflow-cps
  workflow-cps-global-lib
  workflow-durable-task-step
  workflow-job
  workflow-multibranch
  workflow-scm-step
  workflow-step-api
  workflow-support
  ws-cleanup
  xcode-plugin

## Packaging

## Installation

config options

kubernetes URL: https://kubernetes.default.svc.cluster.local
Jenkins URL: http://jenkins.default.svc.cluster.local


## Releasing
To release a new version of this package:

  1. Update [the Jenkins conf][jenkins-conf] to reference the current release of
  the [jenkins-dind][jenkins-dind] Docker image (if needed).
  2. Add some release notes to [CHANGELOG.md](CHANGELOG.md)
  3. Tag the commit on master that you want to be released.

[jenkins-service]: https://hub.docker.com/r/slpcat/kube-jenkins-service
[jenkins-conf]: /conf/jenkins/config.xml
[jenkins-agent]: https://github.com/slpcat/kube-jenkins-dind-agent
[jenkins-home]: https://jenkins-ci.org/
[kubernetes-plugin]: https://plugins.jenkins.io/kubernetes https://github.com/jenkinsci/kubernetes-plugin/blob/master/README.md
[nginx-home]: http://nginx.org/en/
[kubeapps]: https://kubeapps.com/

