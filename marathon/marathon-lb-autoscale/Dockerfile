FROM ruby:2-slim

ENTRYPOINT [ "/marathon-lb-autoscale/autoscale.rb" ]
CMD        [ "--marathon", "http://leader.mesos:8080", "--haproxy", "http://marathon-lb.marathon.mesos:9090" ]

COPY  . /marathon-lb-autoscale
WORKDIR /marathon-lb-autoscale
