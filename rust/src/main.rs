use mlua::{Lua, Value};
use serde_json::Value as JsonValue;
use std::fs;
use std::env;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let debug = env::var("EXOUA_DEBUG").is_ok();

    let lua = Lua::new();
    let code = fs::read_to_string("main.lua")?;
    let value: Value = lua.load(&code).eval()?;

    let json = lua_to_json(value)?;
    let json_string = serde_json::to_string_pretty(&json)?;

    if debug {
        fs::write("level.json", &json_string)?;
    }

    let compressed = exolvl::gzip::compress(json_string.as_bytes())?;
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
