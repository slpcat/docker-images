# Description of GitLab Runner arguments of the register command

The output of 

    docker run -it --name gitlab-runner gitlab/gitlab-runner:latest register --help

is this:

``` 
NAME:
   register - register a new runner

USAGE:
   command register [command options] [arguments...]

OPTIONS:
   -c, --config "/etc/gitlab-runner/config.toml"	Config file [$CONFIG_FILE]
   --tag-list 						Tag list [$RUNNER_TAG_LIST]
   -n, --non-interactive		    Run registration unattended [$REGISTER_NON_INTERACTIVE]
   --leave-runner					Don't remove runner if registration fails [$REGISTER_LEAVE_RUNNER]
   -r, --registration-token 		Runner's registration token [$REGISTRATION_TOKEN]
   --name, --description "f3c40eb54139"			Runner name [$RUNNER_NAME]
   --limit "0"				    	Maximum number of builds processed by this runner [$RUNNER_LIMIT]
   --output-limit "0"				Maximum build trace size in kilobytes [$RUNNER_OUTPUT_LIMIT]
   -u, --url 						Runner URL [$CI_SERVER_URL]
   -t, --token 						Runner token [$CI_SERVER_TOKEN]
   --tls-ca-file 					File containing the certificates to verify the peer when using HTTPS [$CI_SERVER_TLS_CA_FILE]
   --executor 						Select executor, eg. shell, docker, etc. [$RUNNER_EXECUTOR]
   --builds-dir 					Directory where builds are stored [$RUNNER_BUILDS_DIR]
   --cache-dir 						Directory where build cache is stored [$RUNNER_CACHE_DIR]
   --env 					    	Custom environment variables injected to build environment [$RUNNER_ENV]
   --shell 						    Select bash, cmd or powershell [$RUNNER_SHELL]
   --ssh-user 						User name [$SSH_USER]
   --ssh-password 					User password [$SSH_PASSWORD]
   --ssh-host 						Remote host [$SSH_HOST]
   --ssh-port 						Remote host port [$SSH_PORT]
   --ssh-identity-file 				Identity file to be used [$SSH_IDENTITY_FILE]
   --docker-host 					Docker daemon address [$DOCKER_HOST]
   --docker-cert-path 				Certificate path [$DOCKER_CERT_PATH]
   --docker-tlsverify				Use TLS and verify the remote [$DOCKER_TLS_VERIFY]
   --docker-hostname 				Custom container hostname [$DOCKER_HOSTNAME]
   --docker-image 					Docker image to be used [$DOCKER_IMAGE]
   --docker-cpuset-cpus 			String value containing the cgroups CpusetCpus to use [$DOCKER_CPUSET_CPUS]
   --docker-dns 					A list of DNS servers for the container to use [$DOCKER_DNS]
   --docker-dns-search 				A list of DNS search domains [$DOCKER_DNS_SEARCH]
   --docker-privileged				Give extended privileges to container [$DOCKER_PRIVILEGED]
   --docker-cap-add 				Add Linux capabilities [$DOCKER_CAP_ADD]
   --docker-cap-drop 				Drop Linux capabilities [$DOCKER_CAP_DROP]
   --docker-security-opt			Security Options [$DOCKER_SECURITY_OPT]
   --docker-devices 				Add a host device to the container [$DOCKER_DEVICES]
   --docker-disable-cache			Disable all container caching [$DOCKER_DISABLE_CACHE]
   --docker-volumes 				Bind mount a volumes [$DOCKER_VOLUMES]
   --docker-cache-dir 				Directory where to store caches [$DOCKER_CACHE_DIR]
   --docker-extra-hosts 			Add a custom host-to-IP mapping [$DOCKER_EXTRA_HOSTS]
   --docker-network-mode			Add container to a custom network [$DOCKER_NETWORK_MODE]
   --docker-links 					Add link to another container [$DOCKER_LINKS]
   --docker-services 				Add service that is started with container [$DOCKER_SERVICES]
   --docker-wait-for-services-timeout "0"		How long to wait for service startup [$DOCKER_WAIT_FOR_SERVICES_TIMEOUT]
   --docker-allowed-images 			Whitelist allowed images [$DOCKER_ALLOWED_IMAGES]
   --docker-allowed-services 		Whitelist allowed services [$DOCKER_ALLOWED_SERVICES]
   --docker-pull-policy 			Image pull policy: never, if-not-present, always [$DOCKER_PULL_POLICY]
   --parallels-base-name 			VM name to be used [$PARALLELS_BASE_NAME]
   --parallels-template-name 		VM template to be created [$PARALLELS_TEMPLATE_NAME]
   --parallels-disable-snapshots	Disable snapshoting to speedup VM creation [$PARALLELS_DISABLE_SNAPSHOTS]
   --virtualbox-base-name 			VM name to be used [$VIRTUALBOX_BASE_NAME]
   --virtualbox-base-snapshot 		Name or UUID of a specific VM snapshot to clone [$VIRTUALBOX_BASE_SNAPSHOT]
   --virtualbox-disable-snapshots	Disable snapshoting to speedup VM creation [$VIRTUALBOX_DISABLE_SNAPSHOTS]
   --cache-type 					Select caching method: s3, to use S3 buckets [$CACHE_TYPE]
   --cache-s3-server-address 		S3 Server Address [$S3_SERVER_ADDRESS]
   --cache-s3-access-key 	    	S3 Access Key [$S3_ACCESS_KEY]
   --cache-s3-secret-key 			S3 Secret Key [$S3_SECRET_KEY]
   --cache-s3-bucket-name 			S3 bucket name [$S3_BUCKET_NAME]
   --cache-s3-bucket-location 		S3 location [$S3_BUCKET_LOCATION]
   --cache-s3-insecure				Use insecure mode (without https) [$S3_CACHE_INSECURE]
   --machine-idle-nodes "0"			Maximum idle machines [$MACHINE_IDLE_COUNT]
   --machine-idle-time "0"			Minimum time after node can be destroyed [$MACHINE_IDLE_TIME]
   --machine-max-builds "0"			Maximum number of builds processed by machine [$MACHINE_MAX_BUILDS]
   --machine-machine-driver 		The driver to use when creating machine [$MACHINE_DRIVER]
   --machine-machine-name 			The template for machine name (needs to include %s) [$MACHINE_NAME]
   --machine-machine-options 		Additional machine creation options [$MACHINE_OPTIONS]
```