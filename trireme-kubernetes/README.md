# trireme-kubernetes


[![Twitter URL](https://img.shields.io/badge/twitter-follow-blue.svg)](https://twitter.com/aporeto_trireme) [![Slack URL](https://img.shields.io/badge/slack-join-green.svg)](https://triremehq.slack.com/messages/general/) [![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0) [![Documentation](https://img.shields.io/badge/docs-godoc-blue.svg)](https://godoc.org/github.com/aporeto-inc/trireme)
[![Analytics](https://ga-beacon.appspot.com/UA-90327502-1/welcome-page)](https://github.com/igrigorik/ga-beacon)

<img src="docs/trireme.png" width="200">

----

TL;DR? Jump to the **[Getting Started](#getting-started)** section.

Trireme-Kubernetes is a simple, straightforward implementation of the _Kubernetes Network Policies_ specifications. It is independent from the used networking backend and works in _any_ Kubernetes cluster - even in managed Kubernetes clusters like [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine/docs/) or [Azure Container Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/).

One of its powerful features is that you can deploy it to _multiple_ Kubernetes clusters and secure network traffic between specific pods of the different clusters (to secure e.g. MySQL replication or a MongoDB replicaset).

Trireme-Kubernetes builds upon a powerful concept of identity based on standard Kubernetes tags.

It is based on the [Trireme Zero-Trust library](https://go.aporeto.io/trireme-lib).

----
**More on Kubernetes network policies:**

* [Kubernetes NetworkPolicy definition](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
* [Declare NetworkPolicies](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy/)


## Architecture and Components

The architecture of Trireme-Kubernetes is the following:

![Trireme-Kubernetes-Architecture](docs/trireme-kubernetes-architecture.png)

Trireme-Kubernetes consists of several components - not all of them are required:

* [Trireme-Kubernetes](https://github.com/aporeto-inc/trireme-kubernetes): the enforcement service which polices network connections (a.k.a "flows" in Trireme terminology) based on standard `NetworkPolicies` defined on the Kubernetes API

* [Trireme-CSR](https://github.com/aporeto-inc/trireme-csr) (optional): an identity service (basically a CA) that is used to automatically sign certificates and generate asymmetric KeyPairs for each Trireme-Kubernetes instance. Note that this is deployed by default. However, you can exchange it to a simple pre-shared key deployment (PSK) if you really wish to do so.

* [Trireme-Statistics](https://github.com/aporeto-inc/trireme-statistics) (optional): the monitoring and statistics bundle that currently implements the trireme-lib collector interface for InfluxDB. Flows and Container events can be displayed in either Grafana, Chronograf or Trireme-Graph - which shows a generated graph specifically for Kubernetes network flows between pods. Depending on your use-case, some or all of those frontend tools can be deployed.


## Prerequisites

* Trireme requires Kubernetes 1.8.x or later with GA NetworkPolicy support
* Trireme requires `IPTables` with access to the `Mangle` module.
* Trireme requires the `ipset` utility to be installed
* Trireme requires access to the Docker event API socket (`/var/run/docker.sock` by default)
* Trireme requires privileged access.
* When deploying with the `DaemonSet` model (default and recommended), Trireme requires access to the in-cluster Kubernetes service API Token of its pod. Access to the Kubernetes Namespaces/Pods/NetworkPolicies must be available as read-only. **NOTE:** the default deployment takes care of this.


## Getting Started

Trireme-Kubernetes is focused on being simple and straight forward to deploy.
**NOTE:** for any serious deployment, the [extensive deployment guide](deployment/README.md) should be followed.

This section provides a quick and easy way to try Trireme-Kubernetes in your existing cluster.

If you are using GKE or another system on which you don't have admin access (for RBAC / ABAC), make sure you can configure additional ABAC / RBAC rules.
Specifically on GKE you have to ensure that you have full cluster admin rights through RBAC. You can ensure that you do, by running the following command (replace with your account email address):

```
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=YOUR.GOOGLE.CLOUD.EMAIL@EXAMPLE.ORG
```

1) Checkout the deployment files:
```
git clone https://github.com/aporeto-inc/trireme-kubernetes.git
cd trireme-kubernetes/deployment
```

2) Create the `ConfigMap` from this configuration file: (keeping everything by default should be fine)
```
kubectl create -f trireme-config-cm.yaml
```

3) Optionally, deploy the Trireme-Statistics bundle now (this will deploy all possible frontend options):
```
kubectl create -f statistics/
```

4) Create a dummy self-signed _Certificate Authority_ (CA) for Trireme-CSR (the identity service) and add it as a Kubernetes secret (requires the [tg](https://github.com/aporeto-inc/tg) utility - quick install: `go get -u github.com/aporeto-inc/tg`):
```
./gen_pki_ca.sh
```

5) Finally, deploy Trireme-CSR and Trireme-Kubernetes:
```
kubectl create -f trireme/
```

At this point, the whole framework is up and running and you can access the Services in order to display your NetworkPolicy metrics:

```
$ kubectl --namespace=kube-system get services


NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)         AGE
chronograf             ClusterIP      10.43.241.132   <none>          8888/TCP        20h
chronograf-public      LoadBalancer   10.43.254.222   35.194.27.144   80:32153/TCP    20h
grafana                ClusterIP      10.43.241.104   <none>          3000/TCP        20h
grafana-public         LoadBalancer   10.43.241.153   35.194.27.32    80:30716/TCP    20h
graph                  ClusterIP      10.43.248.120   <none>          8080/TCP        20h
graph-public           LoadBalancer   10.43.254.146   35.194.27.212   80:31709/TCP    20h
influxdb               ClusterIP      10.43.245.190   <none>          8086/TCP        20h
```

## Getting started with policy enforcement:

You can test your setup with NetworkPolicies by using an example two-tier application such as [apobeer](https://github.com/aporeto-inc/apobeer)
```
git clone https://github.com/aporeto-inc/apobeer
cd apobeer/kubernetes
kubectl create -f .
```

The deployed [NetworkPolicy](https://github.com/aporeto-inc/apobeer/blob/master/kubernetes/policy.yaml) allows traffic from `frontend` to `backend`, but not from `external` to `backend`


![Kubernetes cluster with Trireme](docs/apobeer.png)

As a result, streaming your logs on any frontend pod should give you a stream of Beers:

```
$ kubectl logs frontend-mffv7 -n beer
The beer of the day is:  "Cantillon Blåbær Lambik"
The beer of the day is:  "Rochefort Trappistes 10"
[...]
```

And as defined by the policy, only `frontend` is able to connect. `external` logs show that it was unable to connect to `backend`:

```
$ kubectl logs external-bww23 -n beer
```

## Kubernetes and Trireme

Kubernetes does not enforce natively NetworkPolicies and requires a third party solution/controller to do so.

Unlike most of the traditional solutions, Trireme is not tight together with a complex networking solution. It therefore gives you the freedom to use one Networking implementation if needed and another NetworkPolicy provider. It acts as the controller to enforce the defined Kubernetes network policies.

Trireme-kubernetes does not rely on any distributed control-plane or setup (no need to plug into `etcd`). Enforcement is performed directly on every node without any shared state propagation (more info at  [Trireme ](https://go.aporeto.io/trireme-lib))


## Advanced deployment and installation options.

Trireme-Kubernetes [can be deployed](https://github.com/aporeto-inc/trireme-kubernetes/tree/master/deployment) as:

* Fully managed by Kubernetes as a `DaemonSet`. (recommended deployment)
* A standalone daemon process on each node.
* A docker container managed outside Kubernetes on each node.


## External materials

* [Slides introducing Trireme-Kubernetes](https://github.com/bvandewalle/kubecon-zerotrust/blob/master/KubeCon%20-%20ZeroTrust.pdf)
* [Talk at Kubecon Berlin (april 2017)](https://www.youtube.com/watch?v=wm7rj2zhXM0&list=PL83F1zbzRHa8gDtbI5zoPpol9bTEIw3Xh)
* [Application segmentation with Trireme for Openshift commons](https://www.youtube.com/watch?v=EjAib6MrW60)
