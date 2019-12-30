use std::env;
use std::process;
use b_error::{BResult, BError};

fn main() {
    b_error::main(run)
}

fn run() -> BResult<()> {
    let (persona, args) = parse_args()?;

    // These functions may not return, and handle exiting the process themselves
    let code = match persona {
        Persona::BeastDb => panic!(),
        Persona::TiDbServer => panic!(),
        Persona::PdServer => driver_go::pd_server_run(&args)?,
        Persona::TiKvServer => panic!(),
    };

    process::exit(code);
}

enum Persona {
    BeastDb,
    TiDbServer,
    PdServer,
    TiKvServer,
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

fn parse_args() -> BResult<(Persona, Vec<String>)> {
    let args = env::args().collect::<Vec<_>>();

    let maybe_persona = if let Some(bin) = args.get(0) {
        bin.split('/').last().map(ToString::to_string)
    } else {
        None
    };

    let (maybe_persona, args) = if let Some(arg1) = args.get(1) {
        if arg1.starts_with('+') {
            let persona = arg1[1..].to_string();
            let args = Some(args[0].clone()).into_iter()
                .chain(args[2..].to_owned().into_iter())
                .collect::<Vec<_>>();
            (Some(persona), args)
        } else {
            (maybe_persona, args)
        }
    } else {
        (maybe_persona, args)
    };

    let maybe_persona = if let Ok(p) = env::var("BEASTDB_PERSONA") {
        Some(p)
    } else {
        maybe_persona
    };

    let persona = if let Some(persona) = maybe_persona {
        str_to_persona(&persona)?
    } else {
        Persona::BeastDb
    };

    Ok((persona, args))
}
