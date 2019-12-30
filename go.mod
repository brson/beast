module github.com/brson/beast

go 1.13

replace github.com/pingcap/pd => ./src/pd

require github.com/pingcap/pd v1.1.0-beta.0.20191119031555-7a5909ed3bae

require (
	github.com/BurntSushi/toml v0.3.1
	github.com/chzyer/readline v0.0.0-20171208011716-f6d7a1f6fbf3
	github.com/coreos/go-semver v0.2.0
	github.com/coreos/pkg v0.0.0-20160727233714-3ac0863d7acf
	github.com/docker/go-units v0.4.0
	github.com/ghodss/yaml v1.0.1-0.20190212211648-25d852aebe32
	github.com/gogo/protobuf v1.0.0
	github.com/golang/protobuf v1.2.0
	github.com/google/btree v0.0.0-20180813153112-4030bb1f1f0c
	github.com/gorilla/mux v1.6.1
	github.com/grpc-ecosystem/go-grpc-prometheus v1.2.0
	github.com/juju/ratelimit v1.0.1
	github.com/mattn/go-shellwords v1.0.3
	github.com/montanaflynn/stats v0.0.0-20151014174947-eeaced052adb
	github.com/opentracing/opentracing-go v1.0.2
	github.com/pingcap/check v0.0.0-20190102082844-67f458068fc8
	github.com/pingcap/errcode v0.0.0-20180921232412-a1a7271709d9
	github.com/pingcap/failpoint v0.0.0-20190512135322-30cc7431d99c
	github.com/pingcap/kvproto v0.0.0-20190516013202-4cf58ad90b6c
	github.com/pingcap/log v0.0.0-20190715063458-479153f07ebd
	github.com/pkg/errors v0.8.1
	github.com/prometheus/client_golang v0.8.0
	github.com/sirupsen/logrus v1.0.5
	github.com/spf13/cobra v0.0.3
	github.com/spf13/pflag v1.0.1
	github.com/syndtr/goleveldb v0.0.0-20180815032940-ae2bd5eed72d
	github.com/unrolled/render v0.0.0-20171102162132-65450fb6b2d3
	github.com/urfave/negroni v0.3.0
	go.etcd.io/etcd v0.0.0-20190320044326-77d4b742cdbf
	go.uber.org/zap v1.9.1
	google.golang.org/grpc v1.14.0
	gopkg.in/natefinch/lumberjack.v2 v2.0.0
)
