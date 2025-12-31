use std::fs;
use std::io::Write;

use anyhow::Result;
use exolvl::{
    types::exolvl::Exolvl,
    types::level_data::LevelData,
    Write as ExoWrite,
};

fn main() -> Result<()> {
    let json_string = fs::read_to_string("level.json")?;

    let mut level_data = LevelData::default();
    level_data.nova_level = true;
    level_data.nova_level_json = Some(json_string);

    let exo = Exolvl {
        local_level: None,
        level_data,
        author_replay: None,
    };

    let mut raw = Vec::new();
    exo.write(&mut raw)?;

    let compressed = exolvl::gzip::compress(&raw)?;
    fs::write("level.exolvl", compressed)?;

    Ok(())
}
