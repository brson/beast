package main

import "C"
import "unsafe"

// pd-server imports
import (
	"context"
	"flag"
	"os"
	"os/signal"
	"syscall"

	grpc_prometheus "github.com/grpc-ecosystem/go-grpc-prometheus"
	"github.com/pingcap/log"
	"github.com/pingcap/pd/pkg/keyvisual"
	"github.com/pingcap/pd/pkg/logutil"
	"github.com/pingcap/pd/pkg/metricutil"
	"github.com/pingcap/pd/server"
	"github.com/pingcap/pd/server/api"
	"github.com/pingcap/pd/server/config"
	"github.com/pingcap/pd/server/join"
	"github.com/pkg/errors"
	"go.uber.org/zap"

	// Register schedulers.
	_ "github.com/pingcap/pd/server/schedulers"
)

func main() { }

//export beast_pd_server_start
func beast_pd_server_start() int32 {
    return 0
}

//export beast_pd_server_run
func beast_pd_server_run(argc int32, argv **C.char) int32 {
    args := import_args(argc, argv)
    pd_server_run(args)
    panic("unreachable")
}

//export beast_pd_ctl_run
func beast_pd_ctl_run() int32 {
    return 0
}

func import_args(argc int32, argv **C.char) []string {
    length := int(argc)
	// TODO: I don't understand what this line is doing
	// https://stackoverflow.com/questions/36188649/cgo-char-to-slice-string
    tmpslice := (*[1 << 30]*C.char)(unsafe.Pointer(argv))[:length:length]
    gostrings := make([]string, length)
    for i, s := range tmpslice {
        gostrings[i] = C.GoString(s)
    }
    return gostrings
}

// copied from pd-server
func pd_server_run(args []string) {
	cfg := config.NewConfig()
	err := cfg.Parse(args[1:])

	if cfg.Version {
		server.PrintPDInfo()
		exit(0)
	}

	defer logutil.LogPanic()

	switch errors.Cause(err) {
	case nil:
	case flag.ErrHelp:
		exit(0)
	default:
		log.Fatal("parse cmd flags error", zap.Error(err))
	}

	if cfg.ConfigCheck {
		server.PrintConfigCheckMsg(cfg)
		exit(0)
	}

	// New zap logger
	err = cfg.SetupLogger()
	if err == nil {
		log.ReplaceGlobals(cfg.GetZapLogger(), cfg.GetZapLogProperties())
	} else {
		log.Fatal("initialize logger error", zap.Error(err))
	}
	// Flushing any buffered log entries
	defer log.Sync()

	// The old logger
	err = logutil.InitLogger(&cfg.Log)
	if err != nil {
		log.Fatal("initialize logger error", zap.Error(err))
	}

	server.LogPDInfo()

	for _, msg := range cfg.WarningMsgs {
		log.Warn(msg)
	}

	// TODO: Make it configurable if it has big impact on performance.
	grpc_prometheus.EnableHandlingTimeHistogram()

	metricutil.Push(&cfg.Metric)

	err = join.PrepareJoinCluster(cfg)
	if err != nil {
		log.Fatal("join meet error", zap.Error(err))
	}

	// Creates server.
	ctx, cancel := context.WithCancel(context.Background())
	svr, err := server.CreateServer(
		ctx,
		cfg,
		api.NewHandler,
		keyvisual.NewKeyvisualService)
	if err != nil {
		log.Fatal("create server failed", zap.Error(err))
	}

	if err = server.InitHTTPClient(svr); err != nil {
		log.Fatal("initial http client for api handler failed", zap.Error(err))
	}

	sc := make(chan os.Signal, 1)
	signal.Notify(sc,
		syscall.SIGHUP,
		syscall.SIGINT,
		syscall.SIGTERM,
		syscall.SIGQUIT)

	var sig os.Signal
	go func() {
		sig = <-sc
		cancel()
	}()

	if err := svr.Run(); err != nil {
		log.Fatal("run server failed", zap.Error(err))
	}

	<-ctx.Done()
	log.Info("Got signal to exit", zap.String("signal", sig.String()))

	svr.Close()
	switch sig {
	case syscall.SIGTERM:
		exit(0)
	default:
		exit(1)
	}
}

func exit(code int) {
	log.Sync()
	os.Exit(code)
}
