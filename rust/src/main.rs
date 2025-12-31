use std::fs;
use std::io::Cursor;

use exolvl::types::exolvl::Exolvl;
use exolvl::{Read as ExoRead, Write as ExoWrite};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let compressed = fs::read("sample.exolvl")?;

    let mut cursor = Cursor::new(compressed);
    let exo = Exolvl::read(&mut cursor)?;

    let mut out = Vec::new();
    exo.write(&mut out)?;

    fs::write("out.exolvl", out)?;
    Ok(())
}
