use std::fs;
use exolvl::{Read, Write};
use exolvl::types::exolvl::Exolvl;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let compressed = fs::read("sample.exolvl")?;

    let raw = exolvl::gzip::read(&compressed)?;

    let exo = Exolvl::read(&mut raw.as_slice())?;

    let mut out_raw = Vec::new();
    exo.write(&mut out_raw)?;

    let out_compressed = exolvl::gzip::compress(&out_raw)?;

    fs::write("out.exolvl", out_compressed)?;

    Ok(())
}
