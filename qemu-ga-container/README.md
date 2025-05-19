# QEMU Guest Agent Container Image

## Overview

This container is designed to run on a minimal container operating system like CoreOS or
Flatcar Linux, running under QEMU/KVM, Proxmox, or other libvirt based virtual machine.
These operating systems often don't have a package management system to easily install the agent.

## Quick Start

Enable the QEMU Guest Agent Channel in the VM configuration.
| VM Host                        | Enable Guest Agent                                            |
| ------------------------------ | ------------------------------------------------------------- |
| QEMU / Virtual Machine Manager | Add the `Guest Agent Channel` device (org.qemu.guest_agent.0) |
| Proxmox                        | Enable the `QEMU Guest Agent` option                          |

### Docker on Fedora CoreOS

```bash
docker run --rm -d --name qemu-ga \
  -v /etc/os-release:/etc/os-release:ro \
  --device /dev/virtio-ports/org.qemu.guest_agent.0:/dev/virtio-ports/org.qemu.guest_agent.0 \
  --net=host \
  --uts=host \
  docker.io/danskadra/qemu-ga
```

This will allow the Guest Agent to retrieve the OS information, host name, and IP addresses of the
container's Host VM.

## Advanced Functionality

If more functionality is required from the Guest Agent, such as reboot and shutdown of non-ACPI VMs,
the following can be used. (This example is for CoreOS)

```bash
docker run --rm -d --name qemu-ga \
  -v /dev:/dev \
  -v /etc/os-release:/etc/os-release:ro \
  -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
  -v /sys/fs/cgroup:/sys/fs/cgroup \
  -v /sbin/shutdown:/sbin/shutdown \
  -v /bin/systemctl:/bin/systemctl \
  -v /usr/lib/systemd:/usr/lib/systemd \
  -v /lib64:/lib64 \
  --privileged \
  --uts=host \
  --net=host \
  docker.io/danskadra/qemu-ga -v
```

⚠ **This is less secure, since the container is now running in privileged mode and generally has
full access to the host VM.**

QEMU Guest Agent falls back on using the `/sbin/shutdown` command to execute reboots and shutdowns.
On a Systemd based OS like CoreOS, `shutdown` is symlinked to the `systemctl` command. For the container
to execute these commands, they need to be mapped into the container as well as the socket and cgroup
dependencies that Systemd requires.

```bash
-v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
-v /sys/fs/cgroup:/sys/fs/cgroup \
-v /sbin/shutdown:/sbin/shutdown \
-v /bin/systemctl:/bin/systemctl \
```

## Resolving Dependency Issues

There is a problem with bind mounting commands into a container when the host's OS and the container's
base OS don't match. Compiled commands are linked against specific versions of GCC and other library
files. The versions of these library files vary from distribution to distribution and even from
different versions of the same distribution.

In the example above, this means that the mounted systemctl command from CoreOS into this Alpine
based container will not run because the container is missing the dependant libraries from the host VM.

The hacky solution is to bind mount the required libraries into the container as well. Use the `ldd`
command to discover the mounted command's dependencies. (Run this on the host VM, not the container)

```bash
ldd /bin/systemctl
        linux-vdso.so.1 (0x00007ffd2117d000)
        libsystemd-shared-251.11-2.fc37.so => /usr/lib/systemd/libsystemd-shared-251.11-2.fc37.so (0x00007f8d1d600000)
        libgcc_s.so.1 => /lib64/libgcc_s.so.1 (0x00007f8d1da85000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f8d1d423000)
        libacl.so.1 => /lib64/libacl.so.1 (0x00007f8d1da7b000)
        libblkid.so.1 => /lib64/libblkid.so.1 (0x00007f8d1da42000)
        libcap.so.2 => /lib64/libcap.so.2 (0x00007f8d1da36000)
        libcrypt.so.2 => /lib64/libcrypt.so.2 (0x00007f8d1d9fc000)
        libkmod.so.2 => /lib64/libkmod.so.2 (0x00007f8d1d9de000)
        liblz4.so.1 => /lib64/liblz4.so.1 (0x00007f8d1d9bb000)
        libmount.so.1 => /lib64/libmount.so.1 (0x00007f8d1d974000)
        libcrypto.so.3 => /lib64/libcrypto.so.3 (0x00007f8d1ce00000)
        libp11-kit.so.0 => /lib64/libp11-kit.so.0 (0x00007f8d1d2ee000)
        libpam.so.0 => /lib64/libpam.so.0 (0x00007f8d1d960000)
        libseccomp.so.2 => /lib64/libseccomp.so.2 (0x00007f8d1d2ce000)
        libselinux.so.1 => /lib64/libselinux.so.1 (0x00007f8d1d2a1000)
        libzstd.so.1 => /lib64/libzstd.so.1 (0x00007f8d1cd4b000)
        liblzma.so.5 => /lib64/liblzma.so.5 (0x00007f8d1d26d000)
        libm.so.6 => /lib64/libm.so.6 (0x00007f8d1cc6b000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f8d1daf1000)
        libattr.so.1 => /lib64/libattr.so.1 (0x00007f8d1d956000)
        libz.so.1 => /lib64/libz.so.1 (0x00007f8d1d253000)
        libffi.so.8 => /lib64/libffi.so.8 (0x00007f8d1d247000)
        libaudit.so.1 => /lib64/libaudit.so.1 (0x00007f8d1cc3d000)
        libeconf.so.0 => /lib64/libeconf.so.0 (0x00007f8d1d23c000)
        libpcre2-8.so.0 => /lib64/libpcre2-8.so.0 (0x00007f8d1cba0000)
        libcap-ng.so.0 => /lib64/libcap-ng.so.0 (0x00007f8d1d230000)
 ```

In this case, this version of CoreOS's systemctl requires libraries located in `/lib64` and
`/usr/lib/systemd/libsystemd-shared-251.11-2.fc37.so`. Because the Alpine container doesn't have
the `/lib64` or `usr/lib/systemd` directories, it's safe and easier to mount the whole directory
from the host VM instead of each library individually.

```bash
-v /sbin/shutdown:/sbin/shutdown
-v /bin/systemctl:/bin/systemctl
-v /usr/lib/systemd:/usr/lib/systemd
-v /lib64:/lib64
```

**Note:** If the host VM's shutdown command or systemctl are linked to libraries in the `/lib` or `/usr/lib`
directories, which exist in the Alpine container, it may be necessary to bind mount each individual
dependant library it to the same directory in the container.

## Useful Options

| Option                                               | Descriptopn                                          |
| ---------------------------------------------------- | ---------------------------------------------------- |
| `-v /etc/os-release:/etc/os-release:ro`              | Read only access to VM OS info                       |
| `--device [VirtIO Serial Port]:[VirtIO Serial Port]` | (**Required**) Agent communication to host VM        |
| `--uts=host`                                         | Allows Guest Agent to read VM hostname               |
| `--net=host`                                         | Allows Guest Agent to read network info from host VM |

## Security Considerations

The QEMU Guest Agent is designed to interact directly with the host operating system.
To allow access to the host while running the Guest Agent inside of a container, the
container may be run with extended capabilities. Generally this is accomplished by
using the `--privileged` command option. This grants far more capabilities to the
container than is needed by the use case presented here. i.e. Retrieving IP addresses,
host names, OS versions, etc, for visibility to the KVM host.

Security can be improved by replacing the `--privileged` option with the `--device`
option and bind mounting a volumes to specific files. This can be used to limit access
to only the VirtIO Guest Agent device, instead of all the devices in /dev or other
capabilities granted by `--privileged`.

If more interaction with the host VM is required, such as rebooting and shutting down the VM, more access
will be required. This will be by either using the `--privileged` option or using the `--cap-add` option
to add specific capabilities to the container.

## Additional Info

- [Container GitHub Repo](https://github.com/dskad/qemu-ga-container)
- [Docker Hub Repo](https://hub.docker.com/r/danskadra/qemu-ga)
- [QEMU Guest Agent Protocol Reference](https://qemu.readthedocs.io/en/latest/interop/qemu-ga-ref.html)
- [Docker Run Reference](https://docs.docker.com/engine/reference/run/)