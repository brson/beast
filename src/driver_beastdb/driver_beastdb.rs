use b_error::BResult;

pub fn beastdb_server_run(args: &[String]) -> BResult<i32> {
    eprintln!("Hi. I'm Beast, the database. I do nothing yet.");
    eprintln!("Try running one of my personas:");
    eprintln!("    beastdb +tidb-server");
    eprintln!("    beastdb +pd-server");
    eprintln!("    beastdb +tikv-server");
    Ok(1)
}
