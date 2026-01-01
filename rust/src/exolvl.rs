use serde::{Deserialize, Serialize};
use std::io::{self, Write};
use uuid::Uuid;

/// Exoracer level format
/// Magic: "NYA^" (0x4E59415E)
/// Version: 19

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Level {
    pub uuid: String,
    pub name: String,
    pub author: String,
    pub theme: String,
    pub objects: Vec<LevelObject>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LevelObject {
    pub obj_type: u32,
    pub position: Vector3,
    pub rotation: Vector3,
    pub scale: Vector3,
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct Vector3 {
    pub x: f32,
    pub y: f32,
    pub z: f32,
}

impl Vector3 {
    pub fn new(x: f32, y: f32, z: f32) -> Self {
        Self { x, y, z }
    }
    
    pub fn zero() -> Self {
        Self::new(0.0, 0.0, 0.0)
    }
    
    pub fn one() -> Self {
        Self::new(1.0, 1.0, 1.0)
    }
}

impl Level {
    pub fn new(name: String, author: String) -> Self {
        Self {
            uuid: Uuid::new_v4().to_string(),
            name,
            author,
            theme: "mountains".to_string(),
            objects: Vec::new(),
        }
    }
    
    pub fn add_object(&mut self, object: LevelObject) {
        self.objects.push(object);
    }
    
    pub fn write<W: Write>(&self, writer: &mut W) -> io::Result<()> {
        // Magic number: "NYA^"
        writer.write_all(&[0x4E, 0x59, 0x41, 0x5E])?;
        
        // Version: 19
        writer.write_all(&19u32.to_le_bytes())?;
        
        // UUID (36 bytes as string with $prefix)
        let uuid_str = format!("${}", self.uuid);
        writer.write_all(uuid_str.as_bytes())?;
        
        // Unknown byte (seems to be object count or flag)
        writer.write_all(&(self.objects.len() as u32).to_le_bytes())?;
        
        // Name length (as single byte) + name
        writer.write_all(&[self.name.len() as u8])?;
        writer.write_all(self.name.as_bytes())?;
        
        // Padding/unknown data (observed pattern from sample)
        // This appears to be author info or metadata
        let author_bytes = self.author.as_bytes();
        writer.write_all(&[0x00])?; // separator
        writer.write_all(&[0xF2, 0xE1, 0xE2, 0x73, 0xB4, 0x48, 0xDE, 0x48])?;
        writer.write_all(&[0x84, 0xC4, 0xB8, 0xAF, 0xB5, 0x48, 0xDE, 0x48])?;
        
        // Padding to align
        for _ in 0..64 {
            writer.write_all(&[0x00])?;
        }
        
        // Object count again
        writer.write_all(&(self.objects.len() as u32).to_le_bytes())?;
        
        // Unknown section (appears in all files)
        writer.write_all(&[0x00, 0x01])?; // flags?
        
        // UUID again
        writer.write_all(uuid_str.as_bytes())?;
        
        // More metadata
        writer.write_all(&1u32.to_le_bytes())?; // version?
        writer.write_all(&1u32.to_le_bytes())?; // flag?
        
        // Padding
        for _ in 0..48 {
            writer.write_all(&[0x00])?;
        }
        
        // Another count/flag section
        writer.write_all(&2u32.to_le_bytes())?;
        writer.write_all(&1u32.to_le_bytes())?;
        writer.write_all(&[0x00, 0x01])?;
        
        // More padding
        for _ in 0..26 {
            writer.write_all(&[0x00])?;
        }
        
        // Object type marker
        writer.write_all(&2u32.to_le_bytes())?;
        writer.write_all(&[0x00, 0x00, 0x00])?;
        
        // More padding (total 128 bytes of zeros observed)
        for _ in 0..128 {
            writer.write_all(&[0x00])?;
        }
        
        // Object count one more time
        writer.write_all(&1u32.to_le_bytes())?;
        
        // More zeros
        for _ in 0..20 {
            writer.write_all(&[0x00])?;
        }
        
        // Theme name length + theme
        writer.write_all(&[self.theme.len() as u8])?;
        writer.write_all(self.theme.as_bytes())?;
        
        // Padding after theme
        for _ in 0..15 {
            writer.write_all(&[0x00])?;
        }
        
        // Float values (appear to be default settings)
        // 1.0 in IEEE 754 = 0x3F800000
        writer.write_all(&1.0f32.to_le_bytes())?; // 0x13C
        writer.write_all(&0.0f32.to_le_bytes())?; 
        writer.write_all(&0.0f32.to_le_bytes())?;
        writer.write_all(&1.0f32.to_le_bytes())?; // 0x148
        writer.write_all(&1.0f32.to_le_bytes())?; // 0x14C
        writer.write_all(&0.0f32.to_le_bytes())?;
        writer.write_all(&0.0f32.to_le_bytes())?;
        writer.write_all(&1.0f32.to_le_bytes())?; // 0x158
        writer.write_all(&1.0f32.to_le_bytes())?; // 0x15C
        writer.write_all(&1.0f32.to_le_bytes())?; // 0x160
        writer.write_all(&1.0f32.to_le_bytes())?; // 0x164
        writer.write_all(&0.0f32.to_le_bytes())?;
        writer.write_all(&0.0f32.to_le_bytes())?;
        writer.write_all(&0.0f32.to_le_bytes())?;
        writer.write_all(&0.0f32.to_le_bytes())?;
        writer.write_all(&0.0f32.to_le_bytes())?;
        
        // Color values (0.833... = 0x3F55D5D6)
        let color_val = 0.8333333f32;
        writer.write_all(&color_val.to_le_bytes())?; // 0x180
        writer.write_all(&color_val.to_le_bytes())?;
        writer.write_all(&color_val.to_le_bytes())?;
        writer.write_all(&1.0f32.to_le_bytes())?; // alpha
        
        // More values (0.3 = 0x3E99999A)
        writer.write_all(&0.3f32.to_le_bytes())?;
        writer.write_all(&0.0f32.to_le_bytes())?;
        writer.write_all(&0.0f32.to_le_bytes())?;
        writer.write_all(&1.0f32.to_le_bytes())?;
        
        // Final flag
        writer.write_all(&1u32.to_le_bytes())?;
        
        // Padding
        for _ in 0..12 {
            writer.write_all(&[0x00])?;
        }
        
        // End marker? (observed: 0x96C20000 = -97.5 as float or just bytes)
        writer.write_all(&[0x96, 0xC2, 0x00, 0x00, 0x00])?;
        
        // TODO: Write actual objects
        // For now, this creates a valid empty level
        
        Ok(())
    }
    
    pub fn to_bytes(&self) -> io::Result<Vec<u8>> {
        let mut buffer = Vec::new();
        self.write(&mut buffer)?;
        Ok(buffer)
    }
}
