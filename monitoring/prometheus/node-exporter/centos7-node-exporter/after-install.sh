#!/bin/bash
systemctl daemon-reload >/dev/null 2>&1 ||:
systemctl enable node_exporter
systemctl restart node_exporter
