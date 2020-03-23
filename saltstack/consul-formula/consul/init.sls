{%- set tplroot = tpldir.split('/')[0] %}
{%- if pillar.get('consul', {}).get('enabled', True) %}
{% from tplroot+"/map.jinja" import consul with context %}

include:
  - {{ tplroot }}.install
  - {{ tplroot }}.config
  - {{ tplroot }}.service

{%- endif %}
