use std::fs;
use std::io::Write;

use exolvl::types::exolvl::Exolvl;
use exolvl::{Read, Write as ExoWrite};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let data = fs::read("sample.exolvl")?;

    let exo = Exolvl::read(&data)?;

    let mut out = Vec::new();
    exo.write(&mut out)?;

    fs::write("out.exolvl", out)?;

    Ok(())
}
