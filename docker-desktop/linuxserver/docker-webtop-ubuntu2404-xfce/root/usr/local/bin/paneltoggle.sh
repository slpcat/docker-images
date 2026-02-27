#!/bin/bash
# Filename:      paneltoggle.sh
# Purpose:       toggle Rox panel on/off from menu
# Authors:       Kerry and anticapitalista for antiX
# Latest change: Sun April 13, 2008.
################################################################################

APP_DIR=`dirname "$0"` export APP_DIR

if [ -f "/tmp/ROX_PANEL_VISIBLE" ]
then
  rm "/tmp/ROX_PANEL_VISIBLE"
  exec rox --top=
else  
  touch "/tmp/ROX_PANEL_VISIBLE"
  exec rox --top=PANEL
fi
