# NuoDB OpenShift CE Template

Public repository for the NuoDB CE OpenShift template.

## Image Availability

The templates reference images stored in the RHCC / Registry. Other images
exist in case you don't have a RHCC account. The templates are parameterized
so you can alter which image you pull. The set of permissible images are as
follows:

| image  | operating system | default  |
|---|---|---|
| registry.connect.redhat.com/nuodb/nuodb-ce:latest  | RHEL 7.5 | yes |
| nuodb/nuodb-ce:latest | CentOS 7.5 | no |

## Running

### Environment

We recommend that you perform your demo using three (3) or four (4) nodes.
However, because your clusters may have more nodes than that, and you may
want to dedicate particular nodes for testing NuoDB, the templates are set
up to permit isolating NuoDB to specified nodes using labels.

While you can run the CE template on a single host, this is not recommended
as you will end up running the transaction engine, storage manager, administration
tier, and client driver -- all on one host.

#### Projects

If you're following along at the command line, create a new project to
test NuoDB out in:

```bash
$ oc new-project test
Now using project "test" on server "https://ec2-52-90-23-139.compute-1.amazonaws.com:8443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git

to build a new example application in Ruby.
```

#### Labeling

To permit isolating the NuoDB CE demo onto dedicated OpenShift nodes, you
must add one label if you're running the `ephemeral` template, and two
labels if you are running the `persistent` template. In each case, the
values for the labels are irrelevant for the CE version, as the templates
simply check for their existence. The following table outlines the labels,
their applicability, etc:

| label  | description  | ephemeral  | persistent  | default |
|---|---|---|---|---|
| nuodb.com/zone  | availability zone or set of nodes to run nuodb on  | yes  | yes  | none |
| nuodb.com/node-type  | type of node, typically `storage` |  no | yes  | none |

Label three or four nodes with the `nuodb.com/zone` label, any value.

Label ONLY one node with the `nuodb.com/node-type` label, with any value.

All pods will run on those labeled nodes only.

For example, to add labels:

```bash
$ oc project test
Already on project "test" on server "https://ec2-52-90-23-139.compute-1.amazonaws.com:8443".

$ oc get nodes -L nuodb.com/zone -L nuodb.com/node-type

$ oc label node ip-10-0-2-152.ec2.internal nuodb.com/zone=east
node "ip-10-0-2-152.ec2.internal" labeled
```

To delete the labels when you're all done:

```bash
$ oc label node ip-10-0-2-152.ec2.internal nuodb.com/zone-
node "ip-10-0-2-152.ec2.internal" labeled
```

Your cluster should look something like this in the end with regards to labeling:

```bash
$ oc get nodes -L nuodb.com/zone -L nuodb.com/node-type
NAME                         STATUS    ROLES     AGE       VERSION             ZONE      NODE-TYPE
ip-10-0-1-139.ec2.internal   Ready     compute   17h       v1.9.1+a0ce1bc657   a         storage
ip-10-0-1-237.ec2.internal   Ready     compute   17h       v1.9.1+a0ce1bc657   a         
ip-10-0-1-74.ec2.internal    Ready     compute   17h       v1.9.1+a0ce1bc657   a         
ip-10-0-1-93.ec2.internal    Ready     compute   17h       v1.9.1+a0ce1bc657   a         
ip-10-0-2-152.ec2.internal   Ready     compute   17h       v1.9.1+a0ce1bc657             
ip-10-0-2-222.ec2.internal   Ready     compute   17h       v1.9.1+a0ce1bc657             
ip-10-0-2-225.ec2.internal   Ready     compute   17h       v1.9.1+a0ce1bc657             
ip-10-0-2-73.ec2.internal    Ready     master    17h       v1.9.1+a0ce1bc657             
ip-10-0-2-81.ec2.internal    Ready     compute   17h       v1.9.1+a0ce1bc657            
```

#### Disable THP

All nodes where you run NuoDB MUST have transparent huge pages (THP) disabled.
Follow instructions online for details on how to do this.

### Create Volumes (Persistent Template ONLY)

The persistent template requires the creation of a storage class and the
creation of a volume. To do so, copy the `local-disk-class.yaml` file to
your master, and install the template:

```bash
$ oc create -f local-disk-class.yaml
storageclass "local-disk" created
persistentvolume "local-disk-0" created
``` 

### Create Red Hat Registry Credentials

First, on the master, login to the Red Hat Registry (sample commands below):

```bash
$ docker login registry.connect.redhat.com
Username: bbuck-nuodb
Password: 
Login Succeeded
```

Verify you can pull the image:

```bash
$ docker pull registry.connect.redhat.com/nuodb/nuodb-ce
Using default tag: latest
latest: Pulling from nuodb/nuodb-ce
367d84554057: Pull complete 
b82a357e4f15: Pull complete 
96296ea486ee: Pull complete 
14bbc3786d2b: Pull complete 
f55b442ea0f5: Pull complete 
73f063cf906e: Pull complete 
869f7c78f7eb: Pull complete 
ad0c66c71644: Pull complete 
b64dc45d05b3: Pull complete 
707d73cc01af: Pull complete 
Digest: sha256:7f818edac51a99a6536b9c78eff83e1460885425d84c84b5c896e09681e7f1f3
Status: Downloaded newer image for registry.connect.redhat.com/nuodb/nuodb-ce:latest
```

Create a Pull Secret:

```bash
$ oc create secret generic nuodb-docker --from-file=.dockerconfigjson=${HOME}/.docker/config.json --type=kubernetes.io/dockerconfigjson
secret "nuodb-docker" created

$ oc secrets link default nuodb-docker --for=pull
```

### Import Template and Go!

Using the OpenShift UI, import and run the template. Follow online instructions
found at nuodb.com.

## Cleaning Up

Simple,

```bash
$ oc delete project test
project "test" deleted
```