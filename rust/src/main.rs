use std::fs;
use std::io::Cursor;

use exolvl::{
    types::exolvl::Exolvl,
    Read,
    Write,
};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let compressed = fs::read("sample.exolvl")?;

    let mut cursor = Cursor::new(compressed);
    let exo = Exolvl::read(&mut cursor)?;

    let mut out = Vec::new();
    exo.write(&mut out)?;

    let compressed_out = exolvl::gzip::compress(&out)?;
    fs::write("out.exolvl", compressed_out)?;

    Ok(())
}
