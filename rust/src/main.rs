use std::fs;
use std::io::Cursor;

use exolvl::types::exolvl::Exolvl;
use exolvl::{Read as ExoRead, Write as ExoWrite};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let compressed = fs::read("sample.exolvl")?;

    let raw = exolvl::gzip::decompress_bytes(&compressed)?;

    let mut cursor = Cursor::new(raw);
    let exo = Exolvl::read(&mut cursor)?;

    let mut out_raw = Vec::new();
    exo.write(&mut out_raw)?;

    let out_compressed = exolvl::gzip::compress(&out_raw)?;
    fs::write("out.exolvl", out_compressed)?;

    Ok(())
}
