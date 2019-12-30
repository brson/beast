module github.com/brson/beast

go 1.13

replace github.com/pingcap/pd => ./src/pd

replace github.com/pingcap/tidb => ./src/tidb

require github.com/pingcap/pd v1.1.0-beta.0.20191119031555-7a5909ed3bae
require github.com/pingcap/tidb v1.1.0-beta.0.20191203054555-84e4386c7a77

require (
	github.com/BurntSushi/toml v0.3.1
	github.com/chzyer/readline v0.0.0-20171208011716-f6d7a1f6fbf3
	github.com/coreos/go-semver v0.2.0
	github.com/coreos/pkg v0.0.0-20180928190104-399ea9e2e55f
	github.com/docker/go-units v0.4.0
	github.com/ghodss/yaml v1.0.1-0.20190212211648-25d852aebe32
	github.com/gogo/protobuf v1.2.0
	github.com/golang/protobuf v1.2.0
	github.com/google/btree v0.0.0-20180813153112-4030bb1f1f0c
	github.com/gorilla/mux v1.6.2
	github.com/grpc-ecosystem/go-grpc-prometheus v1.2.0
	github.com/juju/ratelimit v1.0.1
	github.com/mattn/go-shellwords v1.0.3
	github.com/montanaflynn/stats v0.0.0-20180911141734-db72e6cae808
	github.com/opentracing/opentracing-go v1.0.2
	github.com/pingcap/check v0.0.0-20190102082844-67f458068fc8
	github.com/pingcap/errcode v0.0.0-20180921232412-a1a7271709d9
	github.com/pingcap/errors v0.11.4
	github.com/pingcap/failpoint v0.0.0-20190512135322-30cc7431d99c
	github.com/pingcap/kvproto v0.0.0-20191106014506-c5d88d699a8d
	github.com/pingcap/log v0.0.0-20190715063458-479153f07ebd
	github.com/pingcap/parser v0.0.0-20191120072812-9dc33a611210
	github.com/pingcap/tidb-tools v3.0.6-0.20191119150227-ff0a3c6e5763+incompatible
	github.com/pkg/errors v0.8.1
	github.com/prometheus/client_golang v0.9.0
	github.com/sirupsen/logrus v1.2.0
	github.com/spf13/cobra v0.0.3
	github.com/spf13/pflag v1.0.1
	github.com/struCoder/pidusage v0.1.2
	github.com/syndtr/goleveldb v0.0.0-20180815032940-ae2bd5eed72d
	github.com/unrolled/render v0.0.0-20180914162206-b9786414de4d
	github.com/urfave/negroni v0.3.0
	go.etcd.io/etcd v0.0.0-20190320044326-77d4b742cdbf
	go.uber.org/zap v1.9.1
	google.golang.org/grpc v1.17.0
	gopkg.in/natefinch/lumberjack.v2 v2.0.0
)
