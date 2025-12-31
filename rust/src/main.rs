use std::fs;
use std::io::{Cursor, Read, Write};

use flate2::read::GzDecoder;
use flate2::write::GzEncoder;
use flate2::Compression;

use exolvl::types::exolvl::Exolvl;
use exolvl::{Read as ExoRead, Write as ExoWrite};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let compressed = fs::read("sample.exolvl")?;

    let mut decoder = GzDecoder::new(&compressed[..]);
    let mut raw = Vec::new();
    decoder.read_to_end(&mut raw)?;

    let mut cursor = Cursor::new(raw);
    let exo = Exolvl::read(&mut cursor)?;

    let mut out_raw = Vec::new();
    exo.write(&mut out_raw)?;

    let mut encoder = GzEncoder::new(Vec::new(), Compression::default());
    encoder.write_all(&out_raw)?;
    let compressed_out = encoder.finish()?;

    fs::write("out.exolvl", compressed_out)?;

    Ok(())
}
