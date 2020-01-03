use std::process;
use b_error::{BResult, BError};

fn main() {
    b_error::main(run)
}

fn run() -> BResult<()> {
    let (persona, args) = persona::from_env("BEASTDB", str_to_persona)?;

    let code = exec_persona(persona, args)?;

    process::exit(code);
}

enum Persona {
    BeastDb,
    TiDbServer,
    PdServer,
    TiKvServer,
}

impl Default for Persona {
    fn default() -> Persona { Persona::BeastDb }
}

fn str_to_persona(s: &str) -> BResult<Persona> {
    match s {
        "beastdb" => Ok(Persona::BeastDb),
        "tidb-server" => Ok(Persona::TiDbServer),
        "pd-server" => Ok(Persona::PdServer),
        "tikv-server" => Ok(Persona::TiKvServer),
        _ => Err(BError::new(format!("unknown persona, {}", s))),
    }
}

fn exec_persona(persona: Persona, args: Vec<String>) -> BResult<i32> {
    // These functions may not return, and handle exiting the process themselves
    match persona {
        Persona::BeastDb => driver_beastdb::beastdb_server_run(&args),
        Persona::TiDbServer => driver_go::tidb_server_run(&args),
        Persona::PdServer => driver_go::pd_server_run(&args),
        Persona::TiKvServer => driver_tikv_server::tikv_server_run(&args),
    }
}
