clickhouse_sinker
clickhouse_sinker is a sinker program that consumes kafka message and import them to ClickHouse.

Features
Easy to use and deploy, you don't need write any hard code, just care about the configuration file
Custom parser support.
Support multiple sinker tasks, each runs on parallel.
Support multiply kafka and ClickHouse clusters.
Bulk insert (by config bufferSize and flushInterval).
Loop write (when some node crashes, it will retry write the data to the other healthy node)
Uses Native ClickHouse client-server TCP protocol, with higher performance than HTTP.
Install && Run
By binary files (suggested)
Download the binary files from release, choose the executable binary file according to your env, modify the conf files, then run ./clickhouse_sinker -conf conf

By source
Install Golang

Go Get

go get -u github.com/housepower/clickhouse_sinker/...

cd $GOPATH/src/github.com/housepower/clickhouse_sinker

go get -u github.com/kardianos/govendor

# may take a while
govendor sync
Build && Run
go build -o clickhouse_sinker bin/main.go

## modify the config files, set the configuration directory, then run it
./clickhouse_sinker -conf conf
Examples
there is a simple tutorial in Chinese which created by user @taiyang.
Support parsers
 Json
 Csv
Supported data types
 UInt8, UInt16, UInt32, UInt64, Int8, Int16, Int32, Int64
 Float32, Float64
 String
 FixedString
 DateTime(UInt32), Date(UInt16)
 Array(UInt8, UInt16, UInt32, UInt64, Int8, Int16, Int32, Int64)
 Array(Float32, Float64)
 Array(String)
 Array(FixedString)
 Array(DateTime(UInt32), Date(UInt16))
 Nullable
Configuration
See config example

Custom metric parser
You just need to implement the parser interface on your own
type Parser interface {
	Parse(bs []byte) model.Metric
}
See json parser
