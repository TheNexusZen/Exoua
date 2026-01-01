use std::fs;
use std::io::Write;
use std::process::Command;

use flate2::write::GzEncoder;
use flate2::Compression;

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
struct Size {
    #[serde(default = "default_one")]
    width: f32,
    #[serde(default = "default_one")]
    height: f32,
    #[serde(default = "default_one")]
    depth: f32,
}

fn default_one() -> f32 {
    1.0
}

#[derive(Debug, Deserialize, Serialize)]
struct Color {
    #[serde(default = "default_255")]
    r: u8,
    #[serde(default = "default_255")]
    g: u8,
    #[serde(default = "default_255")]
    b: u8,
    #[serde(default = "default_255")]
    a: u8,
}

fn default_255() -> u8 {
    255
}

#[derive(Debug, Deserialize, Serialize)]
struct LevelObject {
    #[serde(rename = "type")]
    obj_type: String,
    pos: Position,
    #[serde(skip_serializing_if = "Option::is_none")]
    size: Option<Size>,
    #[serde(skip_serializing_if = "Option::is_none")]
    color: Option<Color>,
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

// Custom binary format for .exolvl files
// This is a placeholder - you'll need to implement the actual Exoracer format
#[derive(Debug, Serialize, Deserialize)]
struct ExolvlFormat {
    version: u32,
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
    
    // Remove any extra whitespace or newlines
    let json_output = json_output.trim();
    
    println!("Lua output: {}", json_output);

    // Parse JSON from Lua
    let level_data: LevelData = serde_json::from_str(&json_output)?;

    println!("\n=== Level Information ===");
    println!("Name: {}", level_data.metadata.name);
    println!("Author: {}", level_data.metadata.author);
    println!("Version: {}", level_data.metadata.version);
    println!("Objects: {}", level_data.objects.len());
    
    println!("\n=== Objects ===");
    for (i, obj) in level_data.objects.iter().enumerate() {
        println!("  {}. {} at ({}, {}, {})", 
                 i + 1,
                 obj.obj_type, 
                 obj.pos.x, 
                 obj.pos.y, 
                 obj.pos.z);
        
        if let Some(size) = &obj.size {
            println!("     Size: {}x{}x{}", size.width, size.height, size.depth);
        }
        
        if let Some(color) = &obj.color {
            println!("     Color: rgba({}, {}, {}, {})", color.r, color.g, color.b, color.a);
        }
    }

    // Create ExolvlFormat structure
    let exolvl_data = ExolvlFormat {
        version: 1,
        metadata: level_data.metadata,
        objects: level_data.objects,
    };

    // Serialize to binary using bincode
    let binary_data = bincode::serialize(&exolvl_data)?;
    
    println!("\n=== Writing Level File ===");
    println!("Binary size: {} bytes", binary_data.len());

    // Compress with gzip
    let mut encoder = GzEncoder::new(Vec::new(), Compression::default());
    encoder.write_all(&binary_data)?;
    let compressed_data = encoder.finish()?;

    println!("Compressed size: {} bytes", compressed_data.len());

    // Write to file
    fs::write(output_file, compressed_data)?;
    println!("Level written to: {}", output_file);
    
    println!("\n✓ Success!");

    Ok(())
}

// Optional: Function to read and decompress .exolvl files
#[allow(dead_code)]
fn read_exolvl(input_file: &str) -> Result<ExolvlFormat, Box<dyn std::error::Error>> {
    use flate2::read::GzDecoder;
    use std::io::Read;
    
    println!("Reading level from: {}", input_file);
    
    let compressed = fs::read(input_file)?;
    let mut decoder = GzDecoder::new(&compressed[..]);
    let mut decompressed = Vec::new();
    decoder.read_to_end(&mut decompressed)?;
    
    let level: ExolvlFormat = bincode::deserialize(&decompressed)?;
    
    Ok(level)
}
