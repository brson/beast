use b_error::{BResult, StdResultExt};
use std::env;
use std::error::Error as StdError;

// FIXME would be better to use TryFrom instead of the str_to_persona closure
// but I can't get the bounds to work.
pub fn from_env<P, F, E>(env_prefix: &str, str_to_persona: F) -> BResult<(P, Vec<String>)>
where F: Fn(&str) -> Result<P, E>,
      P: Default,
      E: StdError + Sync + Send + 'static,
{
    let args = env::args().collect::<Vec<_>>();

    let maybe_persona = if let Some(bin) = args.get(0) {
        bin.split('/').last().map(ToString::to_string)
    } else {
        None
    };

    let maybe_persona = if let Ok(p) = env::var(format!("{}_PERSONA", env_prefix)) {
        Some(p)
    } else {
        maybe_persona
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

    let persona = if let Some(persona) = maybe_persona {
        str_to_persona(&persona).e()?
    } else {
        P::default()
    };

    Ok((persona, args))
}
