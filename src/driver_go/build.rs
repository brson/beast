use std::env;

fn main() {
    let manifest_dir = env::var("CARGO_MANIFEST_DIR").expect("");
    // This is generated by the beastdb makefile
    println!("cargo:rerun-if-changed={}/../../out/libgolib.a", manifest_dir);
}
