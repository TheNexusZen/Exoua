use std::fs;
use std::fs::File;
use std::io::Write;

use serde_json::Value as JsonValue;

use exolvl::{
    types::{
        object::Object,
        vec2::Vec2,
    },
    Exolvl,
};

use ordered_float::OrderedFloat;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let json: JsonValue =
        serde_json::from_str(&fs::read_to_string("level.json")?)?;

    let mut exo = Exolvl::default();

    let local = exo.local_level_mut();

    if let Some(meta) = json.get("metadata") {
        if let Some(name) = meta.get("name").and_then(|v| v.as_str()) {
            local.level_name = name.to_string();
        }
    }

    if let Some(objects) = json.get("objects").and_then(|v| v.as_array()) {
        for obj in objects {
            let x = obj.get("x").and_then(|v| v.as_f64()).unwrap_or(0.0);
            let y = obj.get("y").and_then(|v| v.as_f64()).unwrap_or(0.0);

            let w = obj.get("w").and_then(|v| v.as_f64()).unwrap_or(1.0);
            let h = obj.get("h").and_then(|v| v.as_f64()).unwrap_or(1.0);

            let mut o = Object::default();

            o.position = Vec2 {
                x: OrderedFloat(x as f32),
                y: OrderedFloat(y as f32),
            };

            o.scale = Vec2 {
                x: OrderedFloat(w as f32),
                y: OrderedFloat(h as f32),
            };

            if let Some(t) = obj.get("type").and_then(|v| v.as_str()) {
                o.tag = t.to_string();
            }

            local.add_object(o);
        }
    }

    let mut raw = Vec::new();
    exolvl::write::write_exolvl(&exo, &mut raw)?;

    let compressed = exolvl::gzip::compress(&raw)?;
    File::create("level.exolvl")?.write_all(&compressed)?;

    Ok(())
}
