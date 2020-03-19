#!/bin/bash
# NOTE: This does not appear to function correctly in containers,
# as ceph-disk activate-journal attempts to start the OSD using
# the init subsystem, which does not exist here.  It should probably
# go away entirely.
set -ex

function osd_activate_journal {
  if [[ -z "${OSD_JOURNAL}" ]];then
    log "ERROR- You must provide a device to build your OSD journal ie: /dev/sdb2"
    exit 1
  fi

  if [ ! -e "${OSD_JOURNAL}" ]; then
    log "ERROR- Journal ${OSD_JOURNAL} does not exist"
    exit 1
   fi

  if [ ! -b "${OSD_JOURNAL}" ]; then
   # no need to activate non-device journals
   return 0;
  fi

  # watch the udev event queue, and exit if all current events are handled
  udevadm settle --timeout=600

  # wait till partition exists
  wait_for_file ${OSD_JOURNAL}

  chown ceph. ${OSD_JOURNAL}
  ceph-disk -v --setuser ceph --setgroup disk activate-journal ${OSD_JOURNAL}
}
