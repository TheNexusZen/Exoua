use mlua::{Lua, Value};
use serde_json::{Value as JsonValue, Map};
use std::fs::File;
use std::io::Write;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let lua = Lua::new();

    let code = std::fs::read_to_string("main.lua")?;
    let value: Value = lua.load(&code).eval()?;

    let json = lua_to_json(value)?;

    let mut file = File::create("level.json")?;
    file.write_all(
        serde_json::to_string_pretty(&json)?.as_bytes()
    )?;

    Ok(())
}

fn lua_to_json(v: Value) -> Result<JsonValue, Box<dyn std::error::Error>> {
    Ok(match v {
        Value::Nil => JsonValue::Null,
        Value::Boolean(b) => JsonValue::Bool(b),
        Value::Integer(i) => JsonValue::Number(i.into()),
        Value::Number(n) => {
            JsonValue::Number(serde_json::Number::from_f64(n).unwrap())
        }
        Value::String(s) => JsonValue::String(s.to_str()?.to_string()),
        Value::Table(t) => {
            let mut map = Map::new();
            let mut array = Vec::new();
            let mut is_array = true;

            for pair in t.pairs::<Value, Value>() {
                let (k, v) = pair?;
                match k {
                    Value::Integer(_) => array.push(lua_to_json(v)?),
                    Value::String(s) => {
                        is_array = false;
                        map.insert(
                            s.to_str()?.to_string(),
                            lua_to_json(v)?
                        );
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
