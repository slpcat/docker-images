# Tag `latest`

This image is based on the master branch of [BIRD](https://github.com/BIRD/bird/). It `EXPOSE`s port 179 and mounts host's directory `./bird` in the container's `/etc/bird` directory; here the `bird.conf` is used to give `bird` the startup configuration and `log` is used by the daemon to write its log.

It has been created to run a playground to test BGP Large Communities: https://github.com/pierky/bgp-large-communities-playground

# Tag `1.6.6`

This image is based on the 1.6.6 version of [BIRD](https://github.com/BIRD/bird/). Both the IPv4 and IPv6 binaries are compiled here.

It has been created to run live tests for the ARouteServer project: https://github.com/pierky/arouteserver

# Tag `1.6.4`

This image is based on the 1.6.4 version of [BIRD](https://github.com/BIRD/bird/). Both the IPv4 and IPv6 binaries are compiled here.

It has been created to run live tests for the ARouteServer project: https://github.com/pierky/arouteserver

# Tag `1.6.3`

This image is based on the 1.6.3 version of [BIRD](https://github.com/BIRD/bird/). Both the IPv4 and IPv6 binaries are compiled here.

It has been created to run live tests for the ARouteServer project: https://github.com/pierky/arouteserver

# Tag `1.6.3-with-rtrlib`

Same as above, but with [rtrlib](https://github.com/rtrlib/rtrlib).

# Tag `2.0.1`

This image is based on the 2.0.1 version of [BIRD](https://github.com/BIRD/bird/).

It has been created to run live tests for the ARouteServer project: https://github.com/pierky/arouteserver

# Tag `2.0.6`

This image is based on the 2.0.6 version of [BIRD](https://github.com/BIRD/bird/).

It has been created to run live tests for the ARouteServer project: https://github.com/pierky/arouteserver

# Tag `2.0.7`

This image is based on the 2.0.7 version of [BIRD](https://github.com/BIRD/bird/).

It has been created to run live tests for the ARouteServer project: https://github.com/pierky/arouteserver

# Disclaimer

These images has been created with the only purpose of being used in a test environment, for labs and interoperability tests. They do not implement any security best practice. Use them at your own risk.

# How to use the `latest` image

Put the [BIRD startup config](http://bird.network.cz/?get_doc&f=bird.html) into `bird/bird.conf`...

```
# mkdir bird
# vim bird/bird.conf
```

... then run the image in detached mode (`-d`) with the local `bird` directory mounted in `/etc/bird`:

```
# docker run -d -v `pwd`/bird:/etc/bird:rw pierky/bird
```

You can verify that `log` gets populated: `cat bird/log`.

Run `docker ps` to get the running container's ID (`153b6165385f` in the example below), then use it to run BIRD's client:

```
# docker exec -it 153b6165385f birdcl
BIRD 1.6.1 ready.
bird> show status
BIRD 1.6.1
Router ID is 192.0.2.4
Current server time is 2016-09-28 16:41:06
Last reboot on 2016-09-28 16:29:24
Last reconfiguration on 2016-09-28 16:29:24
Daemon is up and running
bird>
```

# Author

Pier Carlo Chiodi - https://pierky.com

Blog: https://blog.pierky.com Twitter: [@pierky](https://twitter.com/pierky)

