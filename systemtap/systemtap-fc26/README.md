# container-image-template

[![Build Status](https://travis-ci.org/container-images/systemtap.svg?branch=master)](https://travis-ci.org/container-images/systemtap)

Host OS prepare
Host OS prepare:
Debian, Ubuntu
apt-get -y install linux-headers-$(uname -r)
apt install linux-image-amd64-dbg
CentOS, RHEL, Fedora, Amazon Linux
yum -y install kernel-devel-$(uname -r)

SystemTap running in a container.

docker run --cap-add SYS_MODULE -v /sys/kernel/debug:/sys/kernel/debug -v /usr/src:/usr/src -v /lib/modules:/lib/modules -v /usr/lib/modules/:/usr/lib/modules/ -v /usr/lib/debug:/usr/lib/debug -t -i slpcat/systemtap

## Usage

You can use atomic command to run systemtap container:

```
$ atomic run modularitycontainers/systemtap
```

Once you are in the shell, you can try some simple systemtap scripts:

1. "hello world" with systemtap:
  ```
  $ stap -e 'probe begin { println("hello world"); }'
  hello world
  ^C
  ```

2. script to print backtrace from a selected kernel function:
  ```
  [root@3fe0ab87451e /]# stap -e 'probe kernel.function("generic_make_request") { prinbacktrace() }'
   0xffffffff9b3dd2f0 : generic_make_request+0x0/0x2d0 [kernel]
   0x0 (inexact)
   0xffffffff9b3dd2f0 : generic_make_request+0x0/0x2d0 [kernel]
   0x0 (inexact)
  ```

For complete guide to this container, please see the [help page](https://github.com/container-images/systemtap/blob/master/help/help.md).
