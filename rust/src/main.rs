use mlua::{Lua, Value};
use serde_json::Value as JsonValue;
use anyhow::Result;
use std::fs;
use exolvl::types::exolvl::Exolvl;
use exolvl::types::level_data::LevelData;
use exolvl::Write;

fn main() -> Result<()> {
    let lua = Lua::new();
    let code = fs::read_to_string("main.lua")?;
    let value: Value = lua.load(&code).eval()?;

    let json = lua_to_json(value)?;
    let json_string = serde_json::to_string(&json)?;

    if std::env::var("EXOUA_DEBUG").ok().as_deref() == Some("1") {
        fs::write("level.json", serde_json::to_string_pretty(&json)?)?;
    }

    let mut level_data = LevelData::default();
    level_data.nova_level = true;
    level_data.nova_scripts.push(json_string);

    let exo = Exolvl {
        level_data,
        ..Default::default()
    };

    let mut raw = Vec::new();
    exo.write(&mut raw)?;

    let compressed = exolvl::gzip::compress(&raw)?;
    fs::write("level.exolvl", compressed)?;

    Ok(())
}

fn lua_to_json(v: Value) -> Result<JsonValue> {
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
            let mut array = Vec::new();
            let mut is_array = true;

            for pair in t.pairs::<Value, Value>() {
                let (k, v) = pair?;
                match k {
                    Value::Integer(_) => array.push(lua_to_json(v)?),
                    Value::String(s) => {
                        is_array = false;
                        map.insert(s.to_str()?.to_string(), lua_to_json(v)?);
                    }
                    _ => {}
                }
            }

            if is_array {
                JsonValue::Array(array)
            } else {
                JsonValue::Object(map)
            }
        }
        _ => JsonValue::Null,
    })
}
