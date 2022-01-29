{% from "consul-template/map.jinja" import consul_template with context %}

consul-template-init-script:
  file.managed:
    {% if salt['test.provider']('service').startswith('systemd') %}
    - source: salt://consul-template/files/consul-template.service
    - name: /etc/systemd/system/consul-template.service
    - mode: 0644
    {% elif salt['test.provider']('service') == 'upstart' %}
    - source: salt://consul-template/files/consul-template-upstart.service
    - name: /etc/init/consul-template.conf
    - mode: 0644
    {% endif %}
    {% if consul_template.service != False %}
    - watch_in:
      - service: consul
    {% endif %}

{% if consul_template.service != False %}
consul-template-service:
  service.running:
    - name: consul-template
    - enable: True
    - watch:
      - file: /etc/consul-template.d/*
{% endif %}
