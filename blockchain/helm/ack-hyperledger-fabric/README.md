# Hyperledger Fabric on Kubernetes of Alibaba Cloud Container Service


[Hyperledger Fabric](https://hyperledger.org/projects/fabric) is one of the most popular blockchain infrastructures in the world, which is open sourced and hosted by Linux Foundation.

## Introduction
This chart implements a solution of automatic configuration and deployment for Hyperledger Fabric. The solution is deployed on Kubernetes cluster of Alibaba Cloud Container Service. And the Hyperledger Fabric network can be accessed by CLI, applications and explorers within or outside the Kubernetes cluster.

A NAS (NFS protocol) shared file storage is needed for: 1. distribution of crypto and configurations; 2. data persistences for most services.

Currently v1.0.0 of Hyperledger Fabric is supported. Support for v1.1.x has been in plan.

You can also refer to the [documentation for blockchain solution of Alibaba Cloud Container Service](https://help.aliyun.com/document_detail/60755.html).


## Prerequisites
- A Kubernetes cluster of Alibaba Cloud Container Service has been created. Refer to [guidance document](https://help.aliyun.com/document_detail/53752.html).
- NAS file storage of Alibaba Cloud has been created and mounted to every worker nodes of Kubernetes cluster, and optionally on one master node (for easier management). Refer to [guidance document](https://help.aliyun.com/document_detail/64313.html) (File system related section)


## Installing the Chart

You can use either Helm client or Application Catalog Dashboard of Alibaba Cloud Container Service to install this chart.

Below we will introduce how to install via Helm client.

* To install with default values and into default namespace:
	
	```
	$ helm install --name blockchain-network01 incubator/acs-hyperledger-fabric
	```

* To install with custom values via file and into namespace network02:
	
	```
	$ helm install --namespace network02 --values network02.yaml  --name blockchain-network02 incubator/acs-hyperledger-fabric
	```
	
	Below is an example of the custom value file network02.yaml, which specifies a list of custom NodePorts to avoid conflict with those of network01.
	
	```
	# Sample contents of network02.yaml
	fabricNetwork: network02
	caExternalPortList: ["32054", "32064"]
	ordererExternalPortList: ["32050", "32060", "32070"]
	peerExternalGrpcPortList: ["32051", "32061", "32071", "32081"]
	peerExternalEventPortList: ["32053", "32063", "32073", "32083"]
	```

* After installation, you can use `helm list` or other Helm commands to administer the blockchain network release.

## Testing the Chart

* Use `kubectl` or dashboard to ensure all pods and servies are running
	
* Enter fabric-cli pod:
	
	```
	kubectl exec -it fabric-cli bash
	```
	
* Run Hyperledger Fabric sample CLI test within the fabric-cli pod, which simulates a simple transfer application:
	
	```
	./cli-test.sh
	```
	
* If all succeed, you should see output messages similar to below:
	
	```
	===================== Query on PEER4 on channel 'bankchannel' is successful ===================== 
	Press any key to continue...
	===================== All GOOD, End-2-End execution completed =====================
	```


## Uninstalling the Chart

* To uninstall completely:
	
	```
	$ helm delete --purge blockchain-network01
	```
	
* Remove the shared folder used by the blockchain network. For example, on one node with NAS storage mounted:
	
	```
	$ rm -rf /data/fabric/network01
	```
	

## Debugging the Chart

Since current solution performs quite a number of configurations, generations and template transformations, you may have the need to debug the installation of chart or deployment of blockchain network. Here are some techniques for consideration:

* To debug chart generation and simulate installation:
	
	```
	helm install --dry-run --debug incubator/acs-hyperledger-fabric 2>&1 
	```
	
	Furthermore, you may use [schelm](https://github.com/databus23/schelm) to render the above output into individual yaml files in an output directory:
	
	```
	helm install --dry-run --debug incubator/acs-hyperledger-fabric 2>&1 | schelm -f output/
	```

* To diagnosis chart deployment:
	
	Use Kubernetes commands like `kubectl get pod -o yaml`, `kubectl describe pod`, `kubectl logs`, etc to find out problems and hints. 

## Configuration

The following table lists the configurable parameters of this chart and their default values.

| Parameter                  | Description                        | Default                                                    |
| -----------------------    | ---------------------------------- | ---------------------------------------------------------- |
| `dockerImageRegistry` | Docker image registry. Refer to values.yaml inside this chart for available options.                | `registry.cn-hangzhou.aliyuncs.com/cos-solution`                                        |
| `externalAddress` | Public IP for application outside cluster to access blockchain network | `1.2.3.4` |
| `fabricNetwork` | Name of blockchain network | `network01` |
| `fabricChannel` | Name of initial channel in blockchain network | `bankchannel` |
| `ordererNum` | Number of orderers | `3` |
| `orgNum` | Number of peer organizations. There will be two peers created for each organization for HA. So the total number of peers will be (orgNum * 2) | `2` |
| `ordererDomain` | Domain of orderers | `alibaba.com` |
| `peerDomain` | Domain of peers | `alibaba.com` |
| `caExternalPortList` | NodePort list for CA services | `["31054", "31064"]` |
| `ordererExternalPortList` | NodePort list for orderer services | `["31050", "31060", "31070"]` |
| `peerExternalGrpcPortList` | NodePort list for peer services via gRPC | `["31051", "31061", "31071", "31081"]` |
| `peerExternalEventPortList` | NodePort list for peer services via eventing | `["31053", "31063", "31073", "31083"]` |
| `imagePullPolicy` | Image pull policy | `IfNotPresent` |
| `hyperledgerFabricVersion` | Version of Hyperledger Fabric. Currently only support 1.0.0 | `1.0.0` |


