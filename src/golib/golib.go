package main

import "C"
import "unsafe"
import "github.com/brson/beast/src/golib/pd"

func main() { }

//export beast_pd_server_start
func beast_pd_server_start() int32 {
    return 0
}

//export beast_pd_server_run
func beast_pd_server_run(argc int32, argv **C.char) int32 {
    args := import_args(argc, argv)
    pd.ServerRun(args)
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
