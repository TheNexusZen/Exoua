use std::fs;
use std::io::Cursor;

use anyhow::Result;
use exolvl::types::exolvl::Exolvl;
use exolvl::Write;

fn main() -> Result<()> {
    let json = fs::read_to_string("level.json")?;

    let mut exo = Exolvl::default();

    exo.level_data.metadata.name = "Exoua Level".into();
    exo.level_data.metadata.author = "exoua".into();

    exo.level_data.raw_json = Some(json);

    let mut buffer = Vec::new();
    exo.write(&mut Cursor::new(&mut buffer))?;

    let compressed = exolvl::gzip::compress(&buffer)?;
    fs::write("level.exolvl", compressed)?;

    Ok(())
}
