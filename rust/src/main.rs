use mlua::{Lua, Value};
use serde_json::{Value as JsonValue};
use std::fs;
use std::io::Write;

use exolvl::{
    types::{
        exolvl::Exolvl,
        level_data::LevelData,
        author_replay::AuthorReplay,
        object::Object,
        vec2::Vec2,
        local_level::LocalLevel,
    },
    Write as ExoWrite,
};

use ordered_float::OrderedFloat;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let lua = Lua::new();
    let code = fs::read_to_string("main.lua")?;
    let value: Value = lua.load(&code).eval()?;

    let json = lua_to_json(value)?;
    fs::write("level.json", serde_json::to_string_pretty(&json)?)?;

    json_to_exolvl(&json)?;

    Ok(())
}

fn json_to_exolvl(json: &JsonValue) -> Result<(), Box<dyn std::error::Error>> {
    let mut local = LocalLevel::default();

    if let Some(objects) = json.get("objects").and_then(|v| v.as_array()) {
        for obj in objects {
            let x = obj.get("x").and_then(|v| v.as_f64()).unwrap_or(0.0);
            let y = obj.get("y").and_then(|v| v.as_f64()).unwrap_or(0.0);
            let w = obj.get("w").and_then(|v| v.as_f64()).unwrap_or(1.0);
            let h = obj.get("h").and_then(|v| v.as_f64()).unwrap_or(1.0);

            local.objects.push(Object {
                entity_id: 0,
                tile_id: 0,
                prefab_entity_id: 0,
                prefab_id: 0,
                position: Vec2 {
                    x: OrderedFloat(x as f32),
                    y: OrderedFloat(y as f32),
                },
                scale: Vec2 {
                    x: OrderedFloat(w as f32),
                    y: OrderedFloat(h as f32),
                },
                rotation: OrderedFloat(0.0),
                tag: String::new(),
                properties: Default::default(),
                in_layer: 0,
                in_group: 0,
                group_members: vec![],
            });
        }
    }

    let exo = Exolvl {
        local_level: local,
        level_data: LevelData::default(),
        author_replay: AuthorReplay::default(),
    };

    let mut raw = Vec::new();
    exo.write(&mut raw)?;

    let compressed = exolvl::gzip::compress(&raw)?;
    fs::write("level.exolvl", compressed)?;

    Ok(())
}

fn lua_to_json(v: Value) -> Result<JsonValue, Box<dyn std::error::Error>> {
    Ok(match v {
        Value::Nil => JsonValue::Null,
        Value::Boolean(b) => JsonValue::Bool(b),
        Value::Integer(i) => JsonValue::Number(i.into()),
        Value::Number(n) => JsonValue::Number(serde_json::Number::from_f64(n).unwrap()),
        Value::String(s) => JsonValue::String(s.to_str()?.to_string()),
        Value::Table(t) => {
            let mut obj = serde_json::Map::new();
            let mut arr = Vec::new();
            let mut is_array = true;

            for pair in t.pairs::<Value, Value>() {
                let (k, v) = pair?;
                match k {
                    Value::Integer(_) => arr.push(lua_to_json(v)?),
                    Value::String(s) => {
                        is_array = false;
                        obj.insert(s.to_str()?.to_string(), lua_to_json(v)?);
                    }
                    _ => {}
                }
            }

            if is_array {
                JsonValue::Array(arr)
            } else {
                JsonValue::Object(obj)
            }
        }
        _ => JsonValue::Null,
    })
}
