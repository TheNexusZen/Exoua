use mlua::{Lua, Value};
use serde_json::Value as JsonValue;
use std::fs;
use std::env;

use exolvl::types::exolvl::Exolvl;
use exolvl::types::level_data::LevelData;
use exolvl::types::nova_script::NovaScript;
use exolvl::Write;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let lua = Lua::new();
    let code = fs::read_to_string("main.lua")?;
    let value: Value = lua.load(&code).eval()?;

    let json = lua_to_json(value)?;
    let json_string = serde_json::to_string_pretty(&json)?;

    let debug = env::var("DEBUG_JSON").ok().as_deref() == Some("1");
    if debug {
        fs::write("level.json", &json_string)?;
    }

    let mut level_data = LevelData::default();
    level_data.nova_scripts.push(NovaScript {
        name: "exoua".into(),
        code: json_string,
        enabled: true,
    });

    let exo = Exolvl {
        local_level: None,
        level_data,
        author_replay: Default::default(),
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
        Value::Number(n) => serde_json::Number::from_f64(n)
            .map(JsonValue::Number)
            .unwrap_or(JsonValue::Null),
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
