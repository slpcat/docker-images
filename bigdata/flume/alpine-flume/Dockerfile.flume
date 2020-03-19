FROM probablyfine/flume

ADD flume-example.conf /var/tmp/flume-example.conf

EXPOSE 44444

ENTRYPOINT [ "flume-ng", "agent",
  "-c", "/opt/flume/conf", "-f", "/var/tmp/flume-example.conf", "-n", "docker",
  "-Dflume.root.logger=INFO,console" ]
