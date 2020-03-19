% systemtap (1) Container Image Pages
% Tomas Tomecek
% September 6th, 2017

# NAME
systemtap — programmable system-wide instrumentation system running in a container.

# DESCRIPTION
This container image provides functionality of packages `systemtap`, `systemtap-client` and `systemtap-testsuite`, which contains plenty of examples.

# USAGE
In order to use systemtap successfully, it requires debug information your booted kernel, namely package `kernel-debuginfo`. There are two ways to do this when running systemtap in this container:


 1. Install `kernel-debuginfo` and `kernel-devel` inside container.

 2. Install `kernel-debuginfo` and `kernel-devel` on host system and mount the required files into container.


`kernel-debuginfo` package is usually available in `fedora-debuginfo` repository (or `updates-debuginfo`). So this is how you can install the package:

```
$ dnf install -y --enablerepo="fedora-debuginfo" --enablerepo="updates-debuginfo" kernel-debuginfo-$(uname -r)
```

Please be sure that the `kernel-debuginfo` and `kernel-devel` packages match exactly the kernel you booted. `uname -r` command provides information about running kernel.

Once you figured out the place where to install the required packages, we can proceed with how the container is meant to be started. Let's go through a list of helpful options:

- `--cap-add SYS_MODULE` — systemtap needs to inject a kernel module into running kernel so it requires this capability.

- `-v /sys/kernel/debug:/sys/kernel/debug` — systemtap accesses `/sys/kernel/debug`, you can either mount that filesystem into container, or provide capability `CAP_SYS_ADMIN` to the container so systemtap can mount it.

- `-v /usr/lib/debug:/usr/lib/debug -v /usr/src/kernels:/usr/src/kernels -v /usr/lib/modules/:/usr/lib/modules/` — when you installed the required kernel packages on your host system, these are the places where the files live so with these options you can make them available within the container.

- `--security-opt label:disable` — when mounting directories inside the container, if SELinux is in enforcing mode, the container process may not have permissions to access files which are being mounted from host system. This option prevents changing labels on files which are being mounted inside (`:z` and `:Z` fields of `-v` change labels).

So the resulting commandline may look like this when the packages are installed on your host:
```
$ docker run --cap-add SYS_MODULE -v /sys/kernel/debug:/sys/kernel/debug -v /usr/src/kernels:/usr/src/kernels -v /usr/lib/modules/:/usr/lib/modules/ -v /usr/lib/debug:/usr/lib/debug --security-opt label:disable -t -i f26/tools bash
```

And this could be the commandline when you installed the packages in the container:
```
$ docker run --cap-add SYS_MODULE -v /sys/kernel/debug:/sys/kernel/debug -t -i f26/tools bash
```

You can also use atomic command to invoke the container:

```
$ atomic run f26/systemtap /usr/share/systemtap/examples/io/iotop.stp
```

If you need an inspiration, there is a plenty of examples available in the container:

```
$ ls -lha /usr/share/systemtap/examples/
```


# SECURITY IMPLICATIONS
Please make sure that only trusted users are allowed to invoke systemtap in
your infrastructure, because they are able to inspect every bit of information
which goes through kernel.


# HISTORY
Release 1: initial release

# SEE ALSO

Please consult upstream documentation for more information: https://sourceware.org/systemtap/wiki
You can also read SystemTap Beginners Guide, which is available at Red Hat Customer Portal: https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/SystemTap_Beginners_Guide/index.html
