use serde::{Deserialize, Serialize};
use std::io::{self, Write};

/// Exoracer object types
#[repr(u8)]
#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub enum ObjectType {
    Terrain = 0,
    Platform = 1,
    Killer = 2,
    Checkpoint = 3,
    Start = 4,
    Finish = 5,
    MovingPlatform = 6,
    Boost = 7,
    Teleporter = 8,
}

impl ObjectType {
    pub fn from_string(s: &str) -> Option<Self> {
        match s.to_lowercase().as_str() {
            "terrain" => Some(ObjectType::Terrain),
            "platform" => Some(ObjectType::Platform),
            "killer" | "spike" | "hazard" => Some(ObjectType::Killer),
            "checkpoint" => Some(ObjectType::Checkpoint),
            "start" => Some(ObjectType::Start),
            "finish" => Some(ObjectType::Finish),
            "movingplatform" | "moving_platform" => Some(ObjectType::MovingPlatform),
            "boost" => Some(ObjectType::Boost),
            "teleporter" => Some(ObjectType::Teleporter),
            _ => None,
        }
    }
    
    pub fn to_u8(self) -> u8 {
        self as u8
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Vector3 {
    pub x: f32,
    pub y: f32,
    pub z: f32,
}

impl Vector3 {
    pub fn new(x: f32, y: f32, z: f32) -> Self {
        Self { x, y, z }
    }
    
    pub fn write<W: Write>(&self, writer: &mut W) -> io::Result<()> {
        writer.write_all(&self.x.to_le_bytes())?;
        writer.write_all(&self.y.to_le_bytes())?;
        writer.write_all(&self.z.to_le_bytes())?;
        Ok(())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Color {
    pub r: u8,
    pub g: u8,
    pub b: u8,
    pub a: u8,
}

impl Color {
    pub fn new(r: u8, g: u8, b: u8, a: u8) -> Self {
        Self { r, g, b, a }
    }
    
    pub fn white() -> Self {
        Self::new(255, 255, 255, 255)
    }
    
    pub fn write<W: Write>(&self, writer: &mut W) -> io::Result<()> {
        writer.write_all(&[self.r, self.g, self.b, self.a])?;
        Ok(())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LevelObject {
    pub object_type: ObjectType,
    pub position: Vector3,
    pub size: Vector3,
    pub rotation: Vector3,
    pub color: Color,
}

impl LevelObject {
    pub fn new(object_type: ObjectType, position: Vector3) -> Self {
        Self {
            object_type,
            position,
            size: Vector3::new(1.0, 1.0, 1.0),
            rotation: Vector3::new(0.0, 0.0, 0.0),
            color: Color::white(),
        }
    }
    
    pub fn with_size(mut self, size: Vector3) -> Self {
        self.size = size;
        self
    }
    
    pub fn with_color(mut self, color: Color) -> Self {
        self.color = color;
        self
    }
    
    pub fn write<W: Write>(&self, writer: &mut W) -> io::Result<()> {
        // Write object type as u8
        writer.write_all(&[self.object_type.to_u8()])?;
        
        // Write position
        self.position.write(writer)?;
        
        // Write size
        self.size.write(writer)?;
        
        // Write rotation
        self.rotation.write(writer)?;
        
        // Write color
        self.color.write(writer)?;
        
        Ok(())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LevelMetadata {
    pub name: String,
    pub author: String,
    pub version: u32,
    pub description: String,
}

impl LevelMetadata {
    pub fn new(name: String, author: String) -> Self {
        Self {
            name,
            author,
            version: 1,
            description: String::new(),
        }
    }
    
    pub fn write<W: Write>(&self, writer: &mut W) -> io::Result<()> {
        // Write version as u32 (little-endian)
        writer.write_all(&self.version.to_le_bytes())?;
        
        // Write name length and name
        let name_bytes = self.name.as_bytes();
        writer.write_all(&(name_bytes.len() as u32).to_le_bytes())?;
        writer.write_all(name_bytes)?;
        
        // Write author length and author
        let author_bytes = self.author.as_bytes();
        writer.write_all(&(author_bytes.len() as u32).to_le_bytes())?;
        writer.write_all(author_bytes)?;
        
        // Write description length and description
        let desc_bytes = self.description.as_bytes();
        writer.write_all(&(desc_bytes.len() as u32).to_le_bytes())?;
        writer.write_all(desc_bytes)?;
        
        Ok(())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Level {
    pub metadata: LevelMetadata,
    pub objects: Vec<LevelObject>,
}

impl Level {
    pub fn new(metadata: LevelMetadata) -> Self {
        Self {
            metadata,
            objects: Vec::new(),
        }
    }
    
    pub fn add_object(&mut self, object: LevelObject) {
        self.objects.push(object);
    }
    
    pub fn write<W: Write>(&self, writer: &mut W) -> io::Result<()> {
        // Write magic number/header (0x45584F4C = "EXOL" in ASCII)
        writer.write_all(&0x45584F4C_u32.to_le_bytes())?;
        
        // Write format version
        writer.write_all(&1_u32.to_le_bytes())?;
        
        // Write metadata
        self.metadata.write(writer)?;
        
        // Write object count
        writer.write_all(&(self.objects.len() as u32).to_le_bytes())?;
        
        // Write all objects
        for object in &self.objects {
            object.write(writer)?;
        }
        
        Ok(())
    }
    
    pub fn to_bytes(&self) -> io::Result<Vec<u8>> {
        let mut buffer = Vec::new();
        self.write(&mut buffer)?;
        Ok(buffer)
    }
  }
