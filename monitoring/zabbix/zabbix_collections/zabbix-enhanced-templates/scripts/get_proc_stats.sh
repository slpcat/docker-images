#!/bin/bash

fn_help() {
  echo "*** Error: ${1} ***"
  echo -e "\n Usage:"
  echo -e "\n  For discovery: ${0} <json> discovery or ${0} <json> net_discovery"
  echo "   * Example #1: Discover process pids with exactly names \"trivial-rewrite\" and \"qmgr\" that are owned by postfix and discover process pids with \"zabbix\" on its name and \"/usr/bin\" regexp on its entire command line -> ${0} '{\"postfix\":{\"exactly\":[\"trivial-rewrite\",\"qmgr\"]},\"root\":{\"name\":[\"zabbix\",\"ssh\"],\"cmd\":[\"/usr/bin\"]}}' discovery"
  echo "   * Example #2: ${0} '{\"postfix\":{\"exactly\":[\"trivial-rewrite\",\"qmgr\"]},\"root\":{\"name\":[\"zabbix\",\"ssh\"],\"cmd\":[\"/bin/sh\"]}}' discovery"
  echo -e "\n  For counters: ${0} <pid> <options>"
  echo "   * Example #1: Retreive process file descritors quantity -> ${0} 928 fd"
  echo "   * Example #2: Retreive process state -> ${0} 928 state"
  exit 1
}

fn_check_user() {
  if ! id -u "${1}" >/dev/null 2>&1; then
    fn_help "User ${1} does not exist"
  fi
}

fn_get_procs() {
  PROC_USERS=`jq -r 'keys[]' <<< ${1}`

  for PROC_USER in ${PROC_USERS}; do
    fn_check_user ${PROC_USER}
    SEARCH_TYPES=`jq -r ".[\"${PROC_USER}\"] |keys[]" <<< ${1}`

    for SEARCH_TYPE in $SEARCH_TYPES; do
      case $SEARCH_TYPE in
        cmd ) PGREP_SEARCH_PARAM="-f"
          ;;
        name ) PGREP_SEARCH_PARAM=""
          ;;
        exactly ) PGREP_SEARCH_PARAM="-x"
          ;;
      esac

      PROC_PATTERNS=`jq -r ".[\"${PROC_USER}\"] |.${SEARCH_TYPE} |.[]" <<< ${1}`

      for PROC_PATTERN in ${PROC_PATTERNS}; do
        CMD_RESULT=`pgrep ${PGREP_SEARCH_PARAM} ${PROC_PATTERN} -u ${PROC_USER} -l`

        for i in ${CMD_RESULT}; do
          PROC_NAME=`awk '{print $2}' <<< ${i} | tr -d ':$'`
          PROC_PID=`awk '{print $1}' <<< ${i} | tr -d ':$'`
          ZBX_JSON=`jq -c ".data |= .+ [{\"{#PROC_USER}\" : \"${PROC_USER}\",\"{#PROC_NAME}\" : \"${PROC_NAME}\",\"{#PROC_PID}\" : \"${PROC_PID}\", ${2}}]" <<< ${ZBX_JSON}`
        done

      done

    done

  done
}

IFS="
"

if [ $# -lt 2 ]; then
  fn_help "Missing parameters"
fi

ACTION=${2}
NET_GLOBAL_STAT="/proc/net/dev"
ZBX_JSON='{"data":[]}'

if [ "${ACTION}" != "discovery" ]; then
  STAT="/proc/${1}/stat"
  IO_STAT="/proc/${1}/io"
  FD_STAT="/proc/${1}/fd"
  OOM_STAT="/proc/${1}/oom_score"
  NET_STAT="/proc/${1}/net/dev"
else
  if grep -q '{' <<< ${1}; then
    if ! jq '.' <<< ${1} >/dev/null; then
      fn_help "Invalid JSON"
    fi
  fi
fi

case ${ACTION} in

  net_discovery )
      IFNAMES=`cat ${NET_GLOBAL_STAT} | grep : | awk '{print $1}' |tr -d ' :'`
      for IFNAME in ${IFNAMES}; do
        fn_get_procs ${1} "\"{#IFNAME}\":\"${IFNAME}\""
      done
      echo ${ZBX_JSON}
    ;;
  discovery )
      fn_get_procs ${1}
      echo ${ZBX_JSON}
    ;;
  fd )
      ls ${FD_STAT} | wc -l
    ;;
  state )
      awk '{ print $3 }' ${STAT}
    ;;
  min_flt ) # https://en.wikipedia.org/wiki/Page_fault#Minor
      awk '{ print $10 }' ${STAT}
    ;;
  cmin_flt )
      awk '{ print $11 }' ${STAT}
    ;;
  maj_flt ) # https://en.wikipedia.org/wiki/Page_fault#Major
      awk '{ print $12 }' ${STAT}
    ;;
  cmaj_flt )
      awk '{ print $13 }' ${STAT}
    ;;
  cpu_usage ) # http://stackoverflow.com/questions/14885598/bash-script-checking-cpu-usage-of-specific-process
      top -b -p ${1} -n 1 | grep ${1} | awk '{print $9}' | sed 's/,/./g'
    ;;
  priority ) # http://superuser.com/questions/203657/difference-between-nice-value-and-priority-in-the-top-output
      awk '{ print $18 }' ${STAT}
    ;;
  nice ) # http://superuser.com/questions/203657/difference-between-nice-value-and-priority-in-the-top-output
      awk '{ print $19 }' ${STAT}
    ;;
  num_threads )
      awk '{ print $20 }' ${STAT}
    ;;
  sigpending ) # Max limit per process: ulimit -i
      awk '{ print $31 }' ${STAT}
    ;;
  sigblocked )
      awk '{ print $32 }' ${STAT}
    ;;
  sigign )
      awk '{ print $33 }' ${STAT}
    ;;
  sigcatch )
      awk '{ print $34 }' ${STAT}
    ;;
  io_syscr ) # https://www.kernel.org/doc/Documentation/filesystems/proc.txt - 3.3  /proc/<pid>/io - Display the IO accounting fields
      grep "^syscr" ${IO_STAT} | awk '{ print $2 }'
    ;;
  io_syscw ) # https://www.kernel.org/doc/Documentation/filesystems/proc.txt - 3.3  /proc/<pid>/io - Display the IO accounting fields
      grep "^syscw" ${IO_STAT} | awk '{ print $2 }'
    ;;
  io_read_bytes ) # https://www.kernel.org/doc/Documentation/filesystems/proc.txt - 3.3  /proc/<pid>/io - Display the IO accounting fields
      grep "^read_bytes" ${IO_STAT} | awk '{ print $2 }'
    ;;
  io_write_bytes ) # https://www.kernel.org/doc/Documentation/filesystems/proc.txt - 3.3  /proc/<pid>/io - Display the IO accounting fields
      grep "^write_bytes" ${IO_STAT} | awk '{ print $2 }'
    ;;
  io_cancelled_write_bytes ) # https://www.kernel.org/doc/Documentation/filesystems/proc.txt - 3.3  /proc/<pid>/io - Display the IO accounting fields
      grep "^cancelled_write_bytes" ${IO_STAT} | awk '{ print $2 }'
    ;;
  oom_score ) # https://www.kernel.org/doc/Documentation/filesystems/proc.txt - 3.2 /proc/<pid>/oom_score - Display current oom-killer score
      cat ${OOM_STAT}
    ;;
  # Memory usage is reported in KB -> need to use a custom mitiplier in zabbix 
  mem_uss ) # http://stackoverflow.com/questions/22372960/is-this-explanation-about-vss-rss-pss-uss-accurately
      smem -c "pid uss" |egrep "^( )?${1}" | awk '{print $2}'
    ;;
  mem_pss ) # http://stackoverflow.com/questions/22372960/is-this-explanation-about-vss-rss-pss-uss-accurately
      smem -c "pid pss" |egrep "^( )?${1}" | awk '{print $2}'
    ;;
  mem_swap )
      smem -c "pid swap" |egrep "^( )?${1}" | awk '{print $2}'
    ;;
  net ) # https://www.kernel.org/doc/Documentation/filesystems/proc.txt - Table 1-9: Network info in /proc/net
        # http://www.onlamp.com/pub/a/linux/2000/11/16/LinuxAdmin.html
      case ${4} in
        # Received
        bytes_in )
            grep ${3}: ${NET_STAT} |awk '{print $2}'
          ;;
        packets_in )
            grep ${3}: ${NET_STAT} |awk '{print $3}'
          ;;
        errs_in )
            grep ${3}: ${NET_STAT} |awk '{print $4}'
          ;;
        drop_in )
            grep ${3}: ${NET_STAT} |awk '{print $5}'
          ;;
        # Transmitted
        bytes_out )
            grep ${3}: ${NET_STAT} |awk '{print $10}'
          ;;
        packets_out )
            grep ${3}: ${NET_STAT} |awk '{print $11}'
          ;;
        errs_out )
            grep ${3}: ${NET_STAT} |awk '{print $12}'
          ;;
        drop_out )
            grep ${3}: ${NET_STAT} |awk '{print $13}'
          ;;

      esac
    ;;
  * ) fn_help
esac
