{% from "consul-template/map.jinja" import consul with context %}

include:
  - consul
  - consul-template.install
  - consul-template.config
  - consul-template.service
