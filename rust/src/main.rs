use mlua::Lua;
use serde_json::Value;
use std::fs;

fn main() -> anyhow::Result<()> {
    let lua = Lua::new();

    let level_lua = fs::read_to_string("lua/level.lua")?;
    lua.load(&level_lua).exec()?;

    let globals = lua.globals();
    let objects: mlua::Table = globals.get("objects")?;

    let json = lua_table_to_json(objects)?;
    fs::write("level.json", serde_json::to_vec_pretty(&json)?)?;

    Ok(())
}

fn lua_table_to_json(table: mlua::Table) -> anyhow::Result<Value> {
    let mut vec = Vec::new();

    for pair in table.sequence_values::<mlua::Table>() {
        let t = pair?;
        let mut obj = serde_json::Map::new();

        for pair in t.pairs::<String, mlua::Value>() {
            let (k, v) = pair?;
            obj.insert(k, lua_value(v)?);
        }

        vec.push(Value::Object(obj));
    }

    Ok(Value::Array(vec))
}

fn lua_value(v: mlua::Value) -> anyhow::Result<Value> {
    Ok(match v {
        mlua::Value::Nil => Value::Null,
        mlua::Value::Boolean(b) => Value::Bool(b),
        mlua::Value::Integer(i) => Value::Number(i.into()),
        mlua::Value::Number(n) => Value::Number(
            serde_json::Number::from_f64(n).unwrap()
        ),
        mlua::Value::String(s) => Value::String(s.to_str()?.to_string()),
        _ => Value::Null
    })
}
