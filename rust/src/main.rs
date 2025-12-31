use std::fs::File;
use std::io::{Read, Write};

use exolvl::{Read as ExoRead, Write as ExoWrite};
use exolvl::types::exolvl::Exolvl;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut input = File::open("sample.exolvl")?;
    let exo = Exolvl::read(&mut input)?;

    let mut output = File::create("out.exolvl")?;
    exo.write(&mut output)?;

    Ok(())
}
