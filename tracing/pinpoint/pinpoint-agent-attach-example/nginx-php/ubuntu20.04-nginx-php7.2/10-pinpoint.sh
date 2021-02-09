#!/bin/bash
set -e
set -x

sed -i "/AgentID=/ s/=.*/=${AGENT_ID}/" /etc/pinpoint_agent.conf
sed -i "/ApplicationName=/ s/=.*/=${APP_NAME}/" /etc/pinpoint_agent.conf
sed -i "/AgentType=/ s/=.*/=${AGENT_TYPE}/" /etc/pinpoint_agent.conf
sed -i "/CollectorSpanIp=/ s/=.*/=${COLLECTOR_IP}/" /etc/pinpoint_agent.conf
sed -i "/CollectorSpanPort=/ s/=.*/=${COLLECTOR_SPAN_PORT}/" /etc/pinpoint_agent.conf
sed -i "/CollectorStatIp=/ s/=.*/=${COLLECTOR_IP}/" /etc/pinpoint_agent.conf
sed -i "/CollectorStatPort=/ s/=.*/=${COLLECTOR_STAT_PORT}/" /etc/pinpoint_agent.conf
sed -i "/CollectorTcpIp=/ s/=.*/=${COLLECTOR_IP}/" /etc/pinpoint_agent.conf
sed -i "/CollectorTcpPort=/ s/=.*/=${COLLECTOR_TCP_PORT}/" /etc/pinpoint_agent.conf
sed -i "/PPLogLevel=/ s/=.*/=${LOGLEVEL}/" /etc/pinpoint_agent.conf
sed -i "/LogFileRootPath=/ s/=.*/=${LOGFILE_ROOTPATH}/" /etc/pinpoint_agent.conf
sed -i "/PluginRootDir=/ s/=.*/=${PLUGIN_ROOTDIR}/" /etc/pinpoint_agent.conf

