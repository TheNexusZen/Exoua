use mlua::{Lua, Value};
use serde_json::{Value as JsonValue, Map};
use std::fs::File;
use std::io::{Write, BufWriter};

use exolvl::{
    Exolvl,
    traits::Writable,
    types::{
        level::Level,
        object::Object,
        vec2::Vec2,
    },
};

use ordered_float::OrderedFloat;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let lua = Lua::new();
    let code = std::fs::read_to_string("main.lua")?;
    let value: Value = lua.load(&code).eval()?;

    let json = lua_to_json(value)?;
    let exo = json_to_exolvl(&json)?;

    let file = File::create("level.exolvl")?;
    let mut writer = BufWriter::new(file);
    exo.write(&mut writer)?;

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
            let mut map = Map::new();
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

fn json_to_exolvl(json: &JsonValue) -> Result<Exolvl, Box<dyn std::error::Error>> {
    let meta = &json["metadata"];
    let objects = &json["objects"];

    let mut level = Level::default();

    for obj in objects.as_array().unwrap() {
        let pos = &obj["pos"];
        let scale = obj.get("scale");

        let mut o = Object::default();

        o.position = Vec2 {
            x: OrderedFloat(pos["x"].as_f64().unwrap() as f32),
            y: OrderedFloat(pos["y"].as_f64().unwrap() as f32),
        };

        if let Some(scale) = scale {
            o.scale = Vec2 {
                x: OrderedFloat(scale["x"].as_f64().unwrap() as f32),
                y: OrderedFloat(scale["y"].as_f64().unwrap() as f32),
            };
        }

        if let Some(tag) = obj.get("type") {
            o.tag = tag.as_str().unwrap().to_string();
        }

        if let Some(props) = obj.get("properties") {
            if let Some(map) = props.as_object() {
                for (k, v) in map {
                    o.properties.insert(k.clone(), v.clone());
                }
            }
        }

        level.objects.push(o);
    }

    Ok(Exolvl {
        local_level: Some(level),
        level_data: None,
        author_replay: None,
    })
}
