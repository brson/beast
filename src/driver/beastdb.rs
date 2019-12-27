use std::process;

fn main() -> ! {
    let code = driver_go::pd_server_run();

    process::exit(code);
}
