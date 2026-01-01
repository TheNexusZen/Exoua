mod exolvl;

use std::fs;
use std::io::Write;
use std::process::Command;

use flate2::write::GzEncoder;
use flate2::Compression;

use serde::{Deserialize, Serialize};

use crate::exolvl::{Color, Level, LevelMetadata, LevelObject, ObjectType, Vector3};

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
struct LuaColor {
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
struct LuaObject {
    #[serde(rename = "type")]
    obj_type: String,
    pos: Position,
    #[serde(skip_serializing_if = "Option::is_none")]
    size: Option<Size>,
    #[serde(skip_serializing_if = "Option::is_none")]
    color: Option<LuaColor>,
}

#[derive(Debug, Deserialize, Serialize)]
struct Metadata {
    name: String,
    author: String,
    version: u32,
}

#[derive(Debug, Deserialize, Serialize)]
struct LuaLevelData {
    metadata: Metadata,
    objects: Vec<LuaObject>,
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
    let json_output = json_output.trim();
    
    println!("Lua output received ({} bytes)", json_output.len());

    // Parse JSON from Lua
    let lua_data: LuaLevelData = serde_json::from_str(&json_output)
        .map_err(|e| format!("Failed to parse JSON: {}", e))?;

    println!("\n=== Level Information ===");
    println!("Name: {}", lua_data.metadata.name);
    println!("Author: {}", lua_data.metadata.author);
    println!("Version: {}", lua_data.metadata.version);
    println!("Objects: {}", lua_data.objects.len());
    
    // Create Level with proper Exoracer format
    let metadata = LevelMetadata::new(
        lua_data.metadata.name,
        lua_data.metadata.author,
    );
    
    let mut level = Level::new(metadata);
    
    println!("\n=== Converting Objects ===");
    for (i, lua_obj) in lua_data.objects.iter().enumerate() {
        // Convert object type
        let obj_type = match ObjectType::from_string(&lua_obj.obj_type) {
            Some(t) => t,
            None => {
                eprintln!("Warning: Unknown object type '{}', defaulting to Terrain", lua_obj.obj_type);
                ObjectType::Terrain
            }
        };
        
        // Convert position
        let position = Vector3::new(lua_obj.pos.x, lua_obj.pos.y, lua_obj.pos.z);
        
        // Create object
        let mut obj = LevelObject::new(obj_type, position);
        
        // Add size if provided
        if let Some(size) = &lua_obj.size {
            obj = obj.with_size(Vector3::new(size.width, size.height, size.depth));
        }
        
        // Add color if provided
        if let Some(color) = &lua_obj.color {
            obj = obj.with_color(Color::new(color.r, color.g, color.b, color.a));
        }
        
        println!("  {}. {:?} at ({}, {}, {})", 
                 i + 1,
                 obj_type, 
                 lua_obj.pos.x, 
                 lua_obj.pos.y, 
                 lua_obj.pos.z);
        
        level.add_object(obj);
    }

    // Serialize to binary using proper Exoracer format
    let binary_data = level.to_bytes()?;
    
    println!("\n=== Writing Level File ===");
    println!("Binary size: {} bytes", binary_data.len());

    // Compress with gzip
    let mut encoder = GzEncoder::new(Vec::new(), Compression::default());
    encoder.write_all(&binary_data)?;
    let compressed_data = encoder.finish()?;

    println!("Compressed size: {} bytes", compressed_data.len());
    println!("Compression ratio: {:.1}%", 
             (compressed_data.len() as f32 / binary_data.len() as f32) * 100.0);

    // Write to file
    fs::write(output_file, compressed_data)?;
    println!("\n✓ Level written to: {}", output_file);
    println!("\n=== Success! ===");

    Ok(())
}
