use mlua::{Lua, Value};
use serde_json::Value as JsonValue;
use std::fs;

use exolvl::types::exolvl::Exolvl;
use exolvl::Read;
use exolvl::Write;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let lua = Lua::new();
    let code = fs::read_to_string("main.lua")?;
    let value: Value = lua.load(&code).eval()?;

    let json = lua_to_json(value)?;
    let _json_string = serde_json::to_string(&json)?;

    let input = fs::read("sample.exolvl")?;
    let exo = Exolvl::read(&mut &input[..])?;

    let mut out = Vec::new();
    exo.write(&mut out)?;

    fs::write("level.exolvl", out)?;
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
