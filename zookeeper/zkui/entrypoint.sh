#!/bin/bash
cd /zkui/target/
sed -i "s/zklist/${ZKLIST}/g" config.cfg
exec "$@"
