use mlua::{Lua, Value};
use serde_json::Value as JsonValue;

use exolvl::{
    types::{
        exolvl::Exolvl,
        local_level::LocalLevel,
        object::Object,
        vec2::Vec2,
    },
    Write,
};

use ordered_float::OrderedFloat;
use std::fs;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let lua = Lua::new();
    let code = fs::read_to_string("main.lua")?;
    let value: Value = lua.load(&code).eval()?;

    let json = lua_to_json(value)?;

    let mut local = LocalLevel::new();

    if let Some(objects) = json.get("objects").and_then(|v| v.as_array()) {
        for obj in objects {
            let x = obj.get("x").and_then(|v| v.as_f64()).unwrap_or(0.0);
            let y = obj.get("y").and_then(|v| v.as_f64()).unwrap_or(0.0);

            let mut o = Object::new();

            o.position = Vec2 {
                x: OrderedFloat(x as f32),
                y: OrderedFloat(y as f32),
            };

            local.entities.push(o);
        }
    }

    let exo = Exolvl {
        local_level: local,
        ..Exolvl::new()
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
        Value::Number(n) => JsonValue::Number(
            serde_json::Number::from_f64(n).unwrap()
        ),
        Value::String(s) => JsonValue::String(s.to_str()?.to_string()),
        Value::Table(t) => {
            let mut map = serde_json::Map::new();
            let mut arr = Vec::new();
            let mut is_array = true;

            for pair in t.pairs::<Value, Value>() {
                let (k, v) = pair?;
                match k {
                    Value::Integer(_) => arr.push(lua_to_json(v)?),
                    Value::String(s) => {
                        is_array = false;
                        map.insert(s.to_str()?.to_string(), lua_to_json(v)?);
                    }
                    _ => {}
                }
            }

            if is_array {
                JsonValue::Array(arr)
            } else {
                JsonValue::Object(map)
            }
        }
        _ => JsonValue::Null,
    })
}
