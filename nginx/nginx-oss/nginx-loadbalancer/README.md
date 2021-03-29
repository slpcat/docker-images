# nginx-loadbalancer [![Docker Repository on Quay.io](https://quay.io/repository/justcontainers/nginx-loadbalancer/status "Docker Repository on Quay.io")](https://quay.io/repository/justcontainers/nginx-loadbalancer)

```
docker run -ti -e CONFD_PREFIX=/lb quay.io/justcontainers/nginx-loadbalancer
```

Backend should follow this rules in order to provide to nginx all required information:

```
/lb
  /settings
    /.nginx = '{}'
  /hosts
    /lisa.contoso.com
      /listeners
        /ls1 = 
          /.nginx = '{}'
          /value = '{
            "protocol": "http",
            "address": "0.0.0.0:80"
          }'
      /locations
        /loc2
          /.nginx = '{}'
          /value = '{
            "path": "/api/.*",
            "upstream": "up1"
          }'
  /upstreams
    /up1
      /servers
        /e1 = '{ "url": "10.10.10.10:8085" }'
        /e2 = '{ "url": "10.10.10.11:8085" }'
    /up2
      /servers
        /e1 = '{ "url": "10.10.10.10:8086" }'
        /e2 = '{ "url": "10.10.10.11:8086" }'
```