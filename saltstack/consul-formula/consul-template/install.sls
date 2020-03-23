{% from "consul-template/map.jinja" import consul_template with context %}

consul-template-config-dir:
  file.directory:
    - name: /etc/consul-template.d

consul-template-template-dir:
  file.directory:
    - name: /etc/consul-template/tmpl-source
    - makedirs: True

# Install template renderer
consul-template-download:
  file.managed:
    - name: /tmp/consul_template_{{ consul_template.version }}_linux_amd64.zip
    - source: https://releases.hashicorp.com/consul-template/{{ consul_template.version }}/consul-template_{{ consul_template.version }}_linux_amd64.zip
    - source_hash: sha256={{ consul_template.hash }}
    - unless: test -f /usr/local/bin/consul-template-{{ consul_template.version }}

consul-template-extract:
  cmd.wait:
    - name: unzip /tmp/consul_template_{{ consul_template.version }}_linux_amd64.zip -d /tmp
    - watch:
      - file: consul-template-download

consul-template-install:
  file.rename:
    - name: /usr/local/bin/consul-template-{{ consul_template.version }}
    - source: /tmp/consul-template
    - require:
      - file: /usr/local/bin
    - watch:
      - cmd: consul-template-extract

consul-template-clean:
  file.absent:
    - name: /tmp/consul_template_{{ consul_template.version }}_linux_amd64.zip
    - watch:
      - file: consul-template-install

consul-template-link:
  file.symlink:
    - target: consul-template-{{ consul_template.version }}
    - name: /usr/local/bin/consul-template
    - watch:
      - file: consul-template-install
