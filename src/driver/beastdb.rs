use std::process;

fn main() -> ! {
    // This function may not return, and instead exit the process itself.
    let code = driver_go::pd_server_run();

    process::exit(code);
}
