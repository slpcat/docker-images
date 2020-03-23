# Tag `latest`

This image is based on the master branch of [OpenBGPD Portable](https://github.com/openbgpd-portable/). It `EXPOSE`s port 179 and mounts host's directory `./bgpd` in the container's `/etc/bgpd` directory; here the `bgpd.conf` is used to give `bgpd` the startup configuration.

# Tag `6.6p0`

This image is based on the 6.6p0 version of [OpenBGPD Portable](https://github.com/openbgpd-portable/).

It has been created to run live tests for the ARouteServer project: https://github.com/pierky/arouteserver

# Tag `6.5p1`

This image is based on the 6.5p1 version of [OpenBGPD Portable](https://github.com/openbgpd-portable/).

It has been created to run live tests for the ARouteServer project: https://github.com/pierky/arouteserver

# Disclaimer

These images have been created with the only purpose of being used in a test environment, for labs and interoperability tests. They do not implement any security best practice. Use them at your own risk.

# How to use the `latest` image

Put the [OpenBGPD](https://man.openbsd.org/bgpd.conf.5) configuration into `bgpd/bgpd.conf`...

```
# mkdir bgpd
# vim bgpd/bgpd.conf
```

... then run the image in detached mode (`-d`) with the local `bgpd` directory mounted in `/etc/bgpd`:

```
# docker run -d -v `pwd`/bgpd:/etc/bgpd:rw pierky/openbgpd
```

# Author

Pier Carlo Chiodi - https://pierky.com

Blog: https://blog.pierky.com Twitter: [@pierky](https://twitter.com/pierky)

