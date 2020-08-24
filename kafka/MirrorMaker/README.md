# EventHubsMirrorMaker
This sample uses Azure Event Hubs Kafka MirrorMaker running on an Azure Container Instance and then it creates a second container as a load generator. Use the Cloud Shell in the Azure portal to give this a try. This will also work from bash if you have the Azure CLI installed.

## Setup a few variables to make your life infinitely easier
```
rgname=mmrg$RANDOM
az group create --name $rgname --location westus
SOURCE=myehkafkasource$RANDOM
DEST=myehkafkadest$RANDOM
```
## Create two Azure Event Hubs and get the connection strings

```
az eventhubs namespace create --name $SOURCE --resource-group $rgname -l westus --enable-kafka true
az eventhubs namespace create --name $DEST --resource-group $rgname -l westus --enable-kafka true
SOURCE_CON_STR=$(az eventhubs namespace authorization-rule keys list --resource-group $rgname --namespace-name $SOURCE --name RootManageSharedAccessKey --query "primaryConnectionString" --output tsv)
DEST_CON_STR=$(az eventhubs namespace authorization-rule keys list --resource-group $rgname --namespace-name $DEST --name RootManageSharedAccessKey --query "primaryConnectionString" --output tsv)
```
Create a container instance to run the built in Kafka perf test sender. The credentials are injected into the container as environment variables. Check out /ehmirror/perfstarter.sh for more details. The same pattern is used for the MirrorMaker container.
```
az container create --resource-group $rgname --name loadgenerator --image confluentinc/cp-kafka --gitrepo-url https://github.com/djrosanova/EventHubsMirrorMaker --gitrepo-mount-path /mnt/EventHubsMirrorMaker --command-line "/bin/bash ./mnt/EventHubsMirrorMaker/ehmirror/perfstarter.sh -d $SOURCE_CON_STR" --restart-policy OnFailure --environment-variables SOURCE_CON_STR="$SOURCE_CON_STR" 
```

Create a container instance to host Mirror Maker. It will see the topic that the above perf container is sending data to and copy it to the second Event Hub / topic. 
```
az container create --resource-group $rgname --name mirrormaker --image confluentinc/cp-kafka --gitrepo-url https://github.com/djrosanova/EventHubsMirrorMaker --gitrepo-mount-path /mnt/EventHubsMirrorMaker --command-line "/bin/bash ./mnt/EventHubsMirrorMaker/ehmirror/mirrorstart.sh " --environment-variables SOURCE_CON_STR="$SOURCE_CON_STR" DEST_CON_STR="$DEST_CON_STR"
```

You can see the details from the mirror maker container with this command.
```
az container show --resource-group $rgname --name mirrormaker
```

Take a look at the logs from the container.
```
az container logs --resource-group $rgname --name mirrormaker
az container logs --resource-group $rgname --name loadgenerator 
```
Clean up all your stuff.
```
az container delete --resource-group $rgname --name mirrormaker
az container delete --resource-group $rgname --name loadgenerator 
az group delete --name $rgname
```
