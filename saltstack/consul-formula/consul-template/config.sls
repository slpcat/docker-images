{% from "consul-template/map.jinja" import consul_template with context %}

consul-template-config:
  file.managed:
    - source: salt://consul-template/files/config.json
    - template: jinja
    - name: /etc/consul-template.d/config.json

{% if consul_template.tmpl %}
{% for tmpl in consul_template.tmpl %}
consul-template-tmpl-file-{{ loop.index }}:
  file.managed:
    - source: {{ tmpl.source }}
    - name: /etc/consul-template/tmpl-source/{{ tmpl.name }}.ctmpl
    - template: {{ tmpl.template_engine }}

consul-template.d-tmpl-{{ loop.index }}:
  file.serialize:
    - name: /etc/consul-template.d/{{ tmpl.name }}.json
    - dataset: {{ tmpl.config }}
    - formatter: json
{% endfor %}
{% endif %}
