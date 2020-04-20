#!/bin/bash
systemctl daemon-reload >/dev/null 2>&1 ||:
systemctl enable consul
systemctl restart consul
