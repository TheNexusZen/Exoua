use std::fs;
use std::io::Cursor;

use exolvl::types::exolvl::Exolvl;
use exolvl::{Read as ExoRead, Write as ExoWrite};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // read a REAL valid exolvl file (your empty sample)
    let compressed = fs::read("sample.exolvl")?;

    // exolvl files are gzip-compressed
    let raw = exolvl::gzip::decompress(&compressed)?;

    // parse
    let mut cursor = Cursor::new(raw);
    let exo = Exolvl::read(&mut cursor)?;

    // write back
    let mut out = Vec::new();
    exo.write(&mut out)?;

    let recompressed = exolvl::gzip::compress(&out)?;
    fs::write("out.exolvl", recompressed)?;

    println!("OK: read + wrote exolvl");

    Ok(())
}
