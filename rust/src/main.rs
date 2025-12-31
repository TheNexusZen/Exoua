use std::fs;
use std::io::Cursor;

use exolvl::types::exolvl::Exolvl;
use exolvl::{Read, Write};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // read compressed .exolvl
    let compressed = fs::read("sample.exolvl")?;

    // decompress
    let decompressed = exolvl::gzip::decompress(&compressed)?;

    // parse exolvl
    let mut cursor = Cursor::new(decompressed);
    let exo = Exolvl::read(&mut cursor)?;

    // write back to raw bytes
    let mut raw = Vec::new();
    exo.write(&mut raw)?;

    // recompress
    let out = exolvl::gzip::compress(&raw)?;

    fs::write("out.exolvl", out)?;

    Ok(())
}
