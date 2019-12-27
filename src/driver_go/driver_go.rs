#![allow(unused)]

use b_error::BResult;

pub fn pd_server_start() -> BResult<()> {
    panic!()
}

pub fn pd_server_run(args: &[String]) -> i32 {
    // FIXME use arguments
    unsafe { ffi::beast_pd_server_run() }
}

pub fn pd_ctl_run() -> i32 {
    panic!()
}

mod ffi {
    #[link(name = "golib", kind="static")]
    extern {
        pub fn beast_pd_server_start() -> i32;
        pub fn beast_pd_server_run() -> i32;
        pub fn beast_pd_ctl_run() -> i32;
    }
}
