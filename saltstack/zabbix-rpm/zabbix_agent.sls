  zabbix_rpm:
    file.managed:
      - name: /var/cache/salt/files/zabbix-agent-4.4.6-1.el7.x86_64.rpm
      - makedirs: True
      - source: salt://zabbix/files/zabbix-agent-4.4.6-1.el7.x86_64.rpm

  zabbix_install:
    cmd.run:
      - name: rpm -Uvh /var/cache/salt/files/zabbix-agent-4.4.6-1.el7.x86_64.rpm || true
      - require:
        - file: zabbix_rpm

  zabbix_agentd.conf:
    file.managed:
      - name: /etc/zabbix/zabbix_agentd.conf
      - makedirs: True
      - source: salt://zabbix/files/zabbix_agentd.conf
      - require:
        - cmd: zabbix_install

  zabbix_run:
    service.running:
      - name: zabbix-agent
      - enable: True
      - reload: True
      - watch:
        - file: zabbix_agentd.conf
