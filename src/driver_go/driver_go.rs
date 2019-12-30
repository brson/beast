#![allow(unused)]

use b_error::{BResult, StdResultExt};
use std::ffi::{CString, CStr};
use std::convert::TryFrom;

pub fn pd_server_start() -> BResult<()> {
    panic!()
}

pub fn pd_server_run(args: &[String]) -> BResult<i32> {
    unsafe { run_with_c_main_args(args, ffi::beast_pd_server_run) }
}

pub fn pd_ctl_run() -> i32 {
    panic!()
}

pub fn tidb_server_run(args: &[String]) -> BResult<i32> {
    unsafe { run_with_c_main_args(args, ffi::beast_tidb_server_run) }
}

unsafe fn run_with_c_main_args(args: &[String], f: unsafe extern "C" fn(i32, *const *const i8) -> i32) -> BResult<i32> {
    let cargs = args.iter().cloned().map(CString::new);
    let cargs = cargs.collect::<Result<Vec<_>, _>>().e()?;
    let cptrs = cargs.iter().map(|s| s.as_ptr()).collect::<Vec<_>>();
    let argc = i32::try_from(cptrs.len()).e()?;
    let argv = cptrs.as_ptr();
    Ok(f(argc, argv))
}

mod ffi {
    #[link(name = "golib", kind="static")]
    extern {
        pub fn beast_pd_server_start() -> i32;
        pub fn beast_pd_server_run(argc: i32, argv: *const *const i8) -> i32;
        pub fn beast_pd_ctl_run() -> i32;
        pub fn beast_tidb_server_run(argc: i32, argv: *const *const i8) -> i32;
    }
}
