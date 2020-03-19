# Using Multiple Ingress Controllers

With the *kubernetes.io/ingress.class* annotation it is possible to smoothly run multiple Ingress controllers at the same time. This could be the case when you deploy your Kubernetes cluster in a cloud provider, for example, Google Compute Engine (GCE). A cloud provider can provide its own Ingress controller enabled by default.

If the annotation is not present in an Ingress resource, which is the usual case, each Ingress controller deployed in the cluster will handle that Ingress. Using the annotation you can specify which Ingress controller must handle which Ingress resource.

To designate that a particular Ingress resource must be handled *only* by the NGINX or NGINX Plus controller add the following annotation along with the value to the Ingress resource:
```
kubernetes.io/ingress.class: "nginx"
```

In this case other Ingress controllers will ignore that Ingress.

To summarize, the NGINX or NGINX Plus controller *will* handle an Ingress resource, if one of the following is true:
* The annotation is not present in the resource
* The annotation is present and its value is either the `nginx` or the empty string

Any other value of the annotation, for example, `gce`, makes the NGINX or NGINX Plus controller ignore the Ingress resource.

Here is an example of an Ingress resource that will be handled *only* by the NGINX or NGINX Plus controller:
```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: cafe-ingress-nginx
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  tls:
  - hosts:
    - cafe.example.com
    secretName: cafe-secret
  rules:
  - host: cafe.example.com
    http:
      paths:
      - path: /tea
        backend:
          serviceName: tea-svc
          servicePort: 80
      - path: /coffee
        backend:
          serviceName: coffee-svc
          servicePort: 80
```
