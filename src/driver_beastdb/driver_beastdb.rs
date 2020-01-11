#![allow(unused)]

use b_error::BResult;

pub fn beastdb_server_run(args: &[String]) -> BResult<i32> {
    b_error::main(run);

    Ok(0)
}

fn run() -> BResult<()> {
    run_pd()?;
    run_tikv()?;
    run_tidb()?;
    wait_for_shutdown()?;

    Ok(())
}

fn run_pd() -> BResult<()> {
    panic!()
}

fn run_tikv() -> BResult<()> {
    panic!()
}

fn run_tidb() -> BResult<()> {
    panic!()
}

fn wait_for_shutdown() -> BResult<()> {
    panic!()
}
