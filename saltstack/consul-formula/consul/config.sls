{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot + '/map.jinja' import consul with context -%}

consul-config:
  file.serialize:
    - name: /etc/consul.d/config.json
    - encoding: utf-8
    - formatter: json
    - dataset: {{ consul.config | json }}
    - user: {{ consul.user }}
    - group: {{ consul.group }}
    - mode: 0640
    - require:
      - user: consul-user
    {%- if consul.service %}
    - watch_in:
       - service: consul
    {%- endif %}

{% for script in consul.scripts %}
consul-script-install-{{ loop.index }}:
  file.managed:
    - source: {{ script.source }}
    - name: {{ script.name }}
    - template: jinja
    - context: {{ script.get('context', {}) | yaml }}
    - user: {{ consul.user }}
    - group: {{ consul.group }}
    - mode: 0755
{% endfor %}

consul-script-config:
  file.serialize:
    - name: /etc/consul.d/services.json
    {% if consul.service != False %}
    - watch_in:
       - service: consul
    {% endif %}
    - user: {{ consul.user }}
    - group: {{ consul.group }}
    - require:
      - user: consul-user
    - formatter: json
    - dataset:
        services: {{ consul.register | json }}
