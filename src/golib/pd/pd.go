package pd

import (
	"context"
	"flag"
	"os"
	"os/signal"
	"syscall"

	grpc_prometheus "github.com/grpc-ecosystem/go-grpc-prometheus"
	log "github.com/pingcap/log"
	"github.com/pingcap/pd/pkg/logutil"
	"github.com/pingcap/pd/pkg/metricutil"
	"github.com/pingcap/pd/server"
	"github.com/pingcap/pd/server/api"
	"github.com/pkg/errors"
	"go.uber.org/zap"

	// Register schedulers.
	_ "github.com/pingcap/pd/server/schedulers"
	// Register namespace classifiers.
	_ "github.com/pingcap/pd/table"
)

func ServerRun(args []string) {
	cfg := server.NewConfig()
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

	err = server.PrepareJoinCluster(cfg)
	if err != nil {
		log.Fatal("join meet error", zap.Error(err))
	}
	svr, err := server.CreateServer(cfg, api.NewHandler)
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

	ctx, cancel := context.WithCancel(context.Background())
	var sig os.Signal
	go func() {
		sig = <-sc
		cancel()
	}()

	if err := svr.Run(ctx); err != nil {
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
