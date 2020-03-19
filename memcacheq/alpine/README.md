# MemcacheQ on Alpine Linux

detail : http://memcachedb.org/memcacheq/

## Volume

* /var/lib/memcacheq

## Usage

```
docker run -d --name memcacheq -p 22201:22201 -v /path/to/volume:/var/lib/memcacheq:rw kazunobufujii/memcacheq
```
