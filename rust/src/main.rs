use std::fs;
use std::io::{Cursor, Read, Write};
use std::process::Command;

use flate2::read::GzDecoder;
use flate2::write::GzEncoder;
use flate2::Compression;

use exolvl::types::exolvl::Exolvl;
use exolvl::{Read as ExoRead, Write as ExoWrite};

use serde::{Deserialize, Serialize};

// Structs to match Lua output
#[derive(Debug, Deserialize, Serialize)]
struct Position {
    x: f32,
    y: f32,
    #[serde(default)]
    z: f32,
}

#[derive(Debug, Deserialize, Serialize)]
struct LevelObject {
    #[serde(rename = "type")]
    obj_type: String,
    pos: Position,
}

#[derive(Debug, Deserialize, Serialize)]
struct Metadata {
    name: String,
    author: String,
    version: u32,
}

#[derive(Debug, Deserialize, Serialize)]
struct LevelData {
    metadata: Metadata,
    objects: Vec<LevelObject>,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = std::env::args().collect();
    
    // Determine input file (default to main.lua)
    let lua_file = if args.len() > 1 {
        &args[1]
    } else {
        "main.lua"
    };

    // Determine output file (default to output.exolvl)
    let output_file = if args.len() > 2 {
        &args[2]
    } else {
        "output.exolvl"
    };

    println!("Reading Lua level from: {}", lua_file);
    
    // Execute Lua and capture output
    let lua_output = Command::new("lua")
        .arg(lua_file)
        .output()?;

    if !lua_output.status.success() {
        eprintln!("Lua execution failed:");
        eprintln!("{}", String::from_utf8_lossy(&lua_output.stderr));
        return Err("Lua script failed".into());
    }

    let json_output = String::from_utf8(lua_output.stdout)?;
    println!("Lua output: {}", json_output);

    // Parse JSON from Lua
    let level_data: LevelData = serde_json::from_str(&json_output)?;

    println!("Parsed level: {}", level_data.metadata.name);
    println!("Author: {}", level_data.metadata.author);
    println!("Objects: {}", level_data.objects.len());

    // Create Exolvl structure
    let mut exo = Exolvl::default();
    
    // TODO: Map level_data to exo structure
    // This depends on the actual exolvl library structure
    // For now, we'll create a basic structure
    
    // Set metadata if possible
    // exo.metadata.name = level_data.metadata.name;
    // exo.metadata.author = level_data.metadata.author;

    // Add objects to exo
    for obj in level_data.objects {
        println!("Processing object: {} at ({}, {})", 
                 obj.obj_type, obj.pos.x, obj.pos.y);
        
        // TODO: Convert obj to exolvl format
        // This requires knowing the exolvl library's object structure
    }

    // Serialize to binary
    let mut out_raw = Vec::new();
    exo.write(&mut out_raw)?;

    // Compress with gzip
    let mut encoder = GzEncoder::new(Vec::new(), Compression::default());
    encoder.write_all(&out_raw)?;
    let compressed_out = encoder.finish()?;

    // Write to file
    fs::write(output_file, compressed_out)?;
    println!("Level written to: {}", output_file);

    Ok(())
}

// Alternative: If you want to read an existing level
#[allow(dead_code)]
fn read_existing_level(input_file: &str, output_file: &str) -> Result<(), Box<dyn std::error::Error>> {
    println!("Reading existing level from: {}", input_file);
    
    let compressed = fs::read(input_file)?;

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

    fs::write(output_file, compressed_out)?;
    println!("Level written to: {}", output_file);

    Ok(())
}
