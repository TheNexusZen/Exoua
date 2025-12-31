use mlua::{Lua, Value};
use exolvl::types::exolvl::Exolvl;
use exolvl::types::local_level::LocalLevel;
use exolvl::types::object::Object;
use exolvl::types::vec2::Vec2;
use exolvl::Write;
use ordered_float::OrderedFloat;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let lua = Lua::new();
    let code = std::fs::read_to_string("main.lua")?;
    let value: Value = lua.load(&code).eval()?;

    let objects = parse_objects(value)?;

    let mut local = LocalLevel::default();
    local.objects = objects;

    let exo = Exolvl {
        local_level: local,
        level_data: Default::default(),
        author_replay: Default::default(),
    };

    let mut raw = Vec::new();
    exo.write(&mut raw)?;

    let compressed = exolvl::gzip::compress(&raw)?;
    std::fs::write("level.exolvl", compressed)?;

    Ok(())
}

fn parse_objects(value: Value) -> Result<Vec<Object>, Box<dyn std::error::Error>> {
    let mut out = Vec::new();

    if let Value::Table(t) = value {
        if let Some(Value::Table(objects)) = t.get("objects")? {
            for pair in objects.sequence_values::<Value>() {
                let obj = pair?;
                if let Value::Table(o) = obj {
                    let x = o.get::<_, f32>("x").unwrap_or(0.0);
                    let y = o.get::<_, f32>("y").unwrap_or(0.0);
                    let w = o.get::<_, f32>("w").unwrap_or(1.0);
                    let h = o.get::<_, f32>("h").unwrap_or(1.0);

                    out.push(Object {
                        position: Vec2 {
                            x: OrderedFloat(x),
                            y: OrderedFloat(y),
                        },
                        scale: Vec2 {
                            x: OrderedFloat(w),
                            y: OrderedFloat(h),
                        },
                        rotation: OrderedFloat(0.0),
                        ..Default::default()
                    });
                }
            }
        }
    }

    Ok(out)
}
