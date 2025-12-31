use std::fs;
use std::io::{Read, Write};

use exolvl::types::exolvl::Exolvl;
use exolvl::{Read as ExoRead, Write as ExoWrite};

use flate2::read::GzDecoder;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let compressed = fs::read("sample.exolvl")?;

    let mut decoder = GzDecoder::new(&compressed[..]);
    let mut raw = Vec::new();
    decoder.read_to_end(&mut raw)?;

    let exo = Exolvl::read(&mut &raw[..])?;

    let mut out_raw = Vec::new();
    exo.write(&mut out_raw)?;

    let recompressed = exolvl::gzip::compress(&out_raw)?;
    fs::write("out.exolvl", recompressed)?;

    Ok(())
}
