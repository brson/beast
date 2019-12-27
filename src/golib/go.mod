module github.com/brson/beast/src/golib

go 1.13

replace github.com/pingcap/pd => ../pd

require (
	github.com/BurntSushi/toml v0.3.1
	github.com/chzyer/readline v0.0.0-20171208011716-f6d7a1f6fbf3
	github.com/coreos/go-semver v0.2.0
	github.com/coreos/pkg v0.0.0-20160727233714-3ac0863d7acf
	github.com/docker/go-units v0.4.0
	github.com/elazarl/go-bindata-assetfs v1.0.0
	github.com/ghodss/yaml v1.0.1-0.20190212211648-25d852aebe32
	github.com/gogo/protobuf v1.0.0
	github.com/golang/protobuf v1.3.2
	github.com/google/btree v0.0.0-20180813153112-4030bb1f1f0c
	github.com/gorilla/mux v1.6.1
	github.com/grpc-ecosystem/go-grpc-prometheus v1.2.0
	github.com/juju/ratelimit v1.0.1
	github.com/mattn/go-shellwords v1.0.3
	github.com/montanaflynn/stats v0.0.0-20151014174947-eeaced052adb
	github.com/opentracing/opentracing-go v1.0.2
	github.com/pingcap/check v0.0.0-20191107115940-caf2b9e6ccf4
	github.com/pingcap/errcode v0.0.0-20180921232412-a1a7271709d9
	github.com/pingcap/failpoint v0.0.0-20191029060244-12f4ac2fd11d
	github.com/pingcap/kvproto v0.0.0-20191213111810-93cb7c623c8b
	github.com/pingcap/log v0.0.0-20191012051959-b742a5d432e9
	github.com/pingcap/pd v2.1.18+incompatible
	github.com/pingcap/sysutil v0.0.0-20191216090214-5f9620d22b3b
	github.com/pkg/errors v0.8.1
	github.com/prometheus/client_golang v0.8.0
	github.com/sirupsen/logrus v1.0.5
	github.com/spf13/cobra v0.0.3
	github.com/spf13/pflag v1.0.1
	github.com/syndtr/goleveldb v0.0.0-20180815032940-ae2bd5eed72d
	github.com/unrolled/render v0.0.0-20171102162132-65450fb6b2d3
	github.com/urfave/negroni v0.3.0
	go.etcd.io/etcd v0.0.0-20190320044326-77d4b742cdbf
	go.uber.org/goleak v0.10.0
	go.uber.org/zap v1.12.0
	google.golang.org/grpc v1.25.1
	gopkg.in/natefinch/lumberjack.v2 v2.0.0
)
