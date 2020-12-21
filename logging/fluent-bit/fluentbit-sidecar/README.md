# Fluent-Bit Sidecar for Kubernetes

Run [Fluent-Bit](http://fluentbit.io/) as a sidecar to collect logs and output them to elasticsearch in a Kubernetes cluster. Fluent-Bit is configured in this example to tail a named directory (for the example: /mnt/log/reference-logging.txt) and collect all logs from the file.

This example includes a log generator app that runs with Fluent-Bit in one pod and writes logs to the named directory. 

## Usage

To deploy in a Kubernetes cluster:

```kubectl -f create fluent-bit-sidecar.yaml```

[Elasticsearch for Kubernetes](https://github.com/kubernetes/kubernetes/tree/master/examples/elasticsearch)

## History

Previously we used FluentD as a log collector and are experimenting with this light-weight Fluent-Bit option. This sidecar example is useful for applications that don't just write logs to STDERR/STDOUT and instead/additionally write logs to a named directory. More details on our experience to come. 