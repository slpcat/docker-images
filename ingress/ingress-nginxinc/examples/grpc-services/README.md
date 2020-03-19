# gRPC support

To add gRPC support to an application with NGINX Ingress controllers, you need to add the **nginx.org/grpc-services** annotation to your Ingress resource definition. The annotation specifies which services are gRPC services. The annotation syntax is as follows:
```
nginx.org/grpc-services: "service1[,service2,...]"
```

In the following example we load balance three applications, one of which is using gRPC:
```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: grpc-ingress
  annotations:
    nginx.org/grpc-services: "grpc-svc"
    kubernetes.io/ingress.class: "nginx"
spec:
  tls:
  - hosts:
    - grpc.example.com
    secretName: grpc-secret
  rules:
  - host: grpc.example.com
    http:
      paths:
      - path: /helloworld.Greeter
        backend:
          serviceName: grpc-svc
          servicePort: 50051
      - path: /tea
        backend:
          serviceName: tea-svc
          servicePort: 80
      - path: /coffee
        backend:
          serviceName: coffee-svc
          servicePort: 80
```
*grpc-svc* is a service for the gRPC application. The service becomes available at the `/helloworld.Greeter` path. Note how we used the **nginx.org/grpc-services** annotation.
