use std::fs;
use std::io::{Read, Write};

use exolvl::{Exolvl, Read as ExoRead, Write as ExoWrite};
use flate2::read::GzDecoder;
use flate2::write::GzEncoder;
use flate2::Compression;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // read compressed file
    let compressed = fs::read("sample.exolvl")?;

    // decompress
    let mut decoder = GzDecoder::new(&compressed[..]);
    let mut raw = Vec::new();
    decoder.read_to_end(&mut raw)?;

    // parse exolvl
    let mut cursor = &raw[..];
    let exo = Exolvl::read(&mut cursor)?;

    // write exolvl back to raw bytes
    let mut out_raw = Vec::new();
    exo.write(&mut out_raw)?;

    // recompress
    let mut encoder = GzEncoder::new(Vec::new(), Compression::default());
    encoder.write_all(&out_raw)?;
    let out_compressed = encoder.finish()?;

    fs::write("out.exolvl", out_compressed)?;

    Ok(())
}
