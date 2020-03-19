# An Elasticsearch Migration Tool

Support cross version and http basic auth.

[![asciicast](https://asciinema.org/a/e562wy1ro30yboznkj5f539md.png)](https://asciinema.org/a/e562wy1ro30yboznkj5f539md)

## Features:

*  Cross version migration supported

*  Overwrite index name

*  Copy index settings and mapping

*  Support http basic auth

*  Support dump into local file

*  Support loading from local file

*  Support http proxy

*  Support sliced scroll (only for elasticsearch 5.0)


## Example:

copy index `index_name` from `192.168.1.x` to `192.168.1.y:9200`

```
./bin/esm  -s http://192.168.1.x:9200   -d http://192.168.1.y:9200 -x index_name  -w=5 -b=10 -c 10000
```

copy index `src_index` from `192.168.1.x` to `192.168.1.y:9200` and save with `dest_index`

```
./bin/esm -s http://localhost:9200 -d http://localhost:9200 -x src_index -y dest_index -w=5 -b=100
```

support Basic-Auth
```
./bin/esm -s http://localhost:9200 -x "src_index" -y "dest_index"  -d http://localhost:9201 -n admin:111111
```

copy settings and override shard size
```
./bin/esm -s http://localhost:9200 -x "src_index" -y "dest_index"  -d http://localhost:9201 -m admin:111111 -c 10000 --shards=50  --copy_settings

```

copy settings and mapping, recreate target index, add query to source fetch, refresh after migration
```
./bin/esm -s http://localhost:9200 -x "src_index" -q=query:phone -y "dest_index"  -d http://localhost:9201  -c 10000 --shards=5  --copy_settings --copy_mappings --force  --refresh

```

dump elasticsearch documents into local file
```
./bin/esm -s http://localhost:9200 -x "src_index"  -m admin:111111 -c 5000 -b -q=query:mixer  --refresh -o=dump.bin 
```

loading data from dump files, bulk insert to another es instance
```
./bin/esm -d http://localhost:9200 -y "dest_index"   -n admin:111111 -c 5000 -b 5 --refresh -i=dump.bin
```

support proxy
```
 ./bin/esm -d http://123345.ap-northeast-1.aws.found.io:9200 -y "dest_index"   -n admin:111111  -c 5000 -b 1 --refresh  -i dump.bin  --dest_proxy=http://127.0.0.1:9743
```

use sliced scroll(only available in elasticsearch v5) to speed scroll, and update shard number
```
 ./bin/esm -s=http://192.168.3.206:9200 -d=http://localhost:9200 -n=elastic:changeme -f --copy_settings --copy_mappings -x=bestbuykaggle  --sliced_scroll_size=5 --shards=50 --refresh
```

## Download
https://github.com/medcl/elasticsearch-dump/releases


## Compile:
if download version is not fill you environment,you may try to compile it yourself. `go` required.

`make build`
* go version >= 1.7

## Options

```
  -s, --source=     source elasticsearch instance
  -d, --dest=       destination elasticsearch instance
  -q, --query=      query against source elasticsearch instance, filter data before migrate, ie: name:medcl
  -m, --source_auth basic auth of source elasticsearch instance, ie: user:pass
  -n, --dest_auth   basic auth of target elasticsearch instance, ie: user:pass
  -c, --count=      number of documents at a time: ie "size" in the scroll request (10000)
  --sliced_scroll_size=      size of sliced scroll, to make it work, the size should be > 1, default:"1"
  -t, --time=       scroll time (1m)
      --shards=     set a number of shards on newly created indexes
      --copy_settings copy index settings from source
      --copy_mappings copy mappings mappings from source
  -f, --force      delete destination index before copying, default:false
  -x, --src_indexes=    list of indexes to copy, comma separated (_all), support wildcard match(*)
  -y, --dest_index=    indexes name to save, allow only one indexname, original indexname will be used if not specified
  -a, --all         copy indexes starting with . and _ (false)
  -w, --workers=    concurrency number for bulk workers, default is: "1"
  -b  --bulk_size 	bulk size in MB" default:5
  -v  --log 	    setting log level,options:trace,debug,info,warn,error
  -i  --input_file  indexing from local dump file, file format: {"_id":"xxx","_index":"xxx","_source":{"xxx":"xxx"},"_type":"xxx"  }
  -o  --output_file output documents of source index into local file, file format same as input_file.
  --source_proxy     set proxy to source http connections, ie: http://127.0.0.1:8080
  --dest_proxy       set proxy to destination http connections, ie: http://127.0.0.1:8080
  --refresh          refresh after migration finished

```

Versions
--------

From       | To
-----------|-----------
1.x | 1.x
1.x | 2.x
1.x | 5.0
2.x | 1.x
2.x | 2.x
2.x | 5.0
5.0 | 1.x
5.0 | 2.x
5.0 | 5.0
6.x | 6.x

