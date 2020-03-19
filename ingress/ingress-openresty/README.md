Kubernetes OpenResty Ingress Controller
=======================================

## Why OpenResty?
I work in an high traffic envoirement where we have tested different reverse proxies. Our tests showed NGINX as the best one on resource usage. But NGINX didn't fit our needs ins customisability, that is why we chose OpenResty as a solution. While this setup is quite minimal we have more stuff going on in our production configuration.

## Why not the NGINX ingress controller
We wanted a minimalistic ingress controller setup. By browsing through the code of the NGINX ingress controller I got an impression of added complexity. Plus it is a nice learning experience as it seems not many people write their own ingress controller.

## Can I just use this with X
Probably yes, in order to allow flexible configuration options this used Go Templating. It should be easy to port this to the reverse proxy of your choise.

## Thank you to
- [traefik](https://github.com/containous/traefik/) For having understandable code on the Kubernetes backend