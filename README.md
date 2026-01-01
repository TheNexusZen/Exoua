# exoua

**Lua-first Exoracer level generator**

`exoua` lets you describe **Exoracer levels using Lua**, then converts them into **`.exolvl` files** with a Rust backend.

- Lua controls everything  
- Rust only writes the final level file  
- Simple, flexible, scriptable  

---

## How It Works

1. You write a level in **Lua** using the `exoua` API  
2. Lua outputs structured level data  
3. Rust reads that data  
4. Rust generates a valid **`.exolvl`** file using the `exolvl` library  

---

## Installation

### Prerequisites

- Lua **5.1+** (or LuaJIT)
- Rust **1.70+**
- Cargo

### Setup

```bash
git clone https://github.com/TheNexusZen/Exoua.git
cd Exoua
cargo build --release
```

---

## Usage

### Basic Example

Create a level in `main.lua`:

```lua
local exoua = require("exoua")

local lvl = exoua.level{
  name = "Test Level",
  author = "Nexus",
  version = 1
}

lvl:start{ pos = exoua.pos(0, 0) }
lvl:terrain{ pos = exoua.pos(0, 0) }
lvl:platform{ pos = exoua.pos(5, 3), size = exoua.size(10, 1) }
lvl:killer{ pos = exoua.pos(3, 1) }
lvl:checkpoint{ pos = exoua.pos(20, 5) }
lvl:finish{ pos = exoua.pos(50, 10) }

return lvl:export()
```

### Generate the Level File

#### Option 1 — Pipe Lua into Rust

```bash
lua main.lua | cargo run --release
```

#### Option 2 — Run built binary

```bash
lua main.lua | ./target/release/exoua
```

#### Option 3 — Rust runs Lua directly

```bash
cargo run --release -- main.lua output.exolvl
```

---

## API Reference

### Core

#### `exoua.level(metadata)`

Creates a new level.

**Parameters**
- `name` (string)
- `author` (string)
- `version` (number)

Returns a **Level object**.

---

### Level Methods

All methods accept a table and return the level (chainable).

- `lvl:start(props)`
- `lvl:terrain(props)`
- `lvl:platform(props)`
- `lvl:killer(props)`
- `lvl:checkpoint(props)`
- `lvl:finish(props)`
- `lvl:object(type, props)`

---

### Helper Functions

- `exoua.pos(x, y, z)`
- `exoua.size(w, h, d)`
- `exoua.color(r, g, b, a)`

---

### Example With Helpers

```lua
local exoua = require("exoua")

local lvl = exoua.level{
  name = "Advanced Level",
  author = "Nexus",
  version = 1
}

lvl:platform{
  pos = exoua.pos(10, 5, 0),
  size = exoua.size(15, 2, 1),
  color = exoua.color(255, 128, 64, 255)
}

lvl:killer{
  pos = exoua.pos(25, 3)
}

return lvl:export()
```

---

## Project Structure

```
Exoua/
├── exoua.lua
├── main.lua
├── json.lua
├── rust/
│   └── src/
│       └── main.rs
├── Cargo.toml
└── README.md
```

---

## Development Status

### Completed

- [x] Lua API for level creation
- [x] JSON export from Lua
- [x] Rust JSON parsing
- [x] Basic object support
- [x] Compression / decompression

### TODO

- [ ] Complete exolvl object mapping
- [ ] Full object type support
- [ ] Physics properties
- [ ] ExoScript / NovaScript support
- [ ] Animations & triggers
- [ ] Validation and error checking
- [ ] Full API documentation
- [ ] CLI improvements
- [ ] Level preview / testing tools

---

## Contributing

1. Fork the repository  
2. Create a feature branch  
3. Make changes  
4. Test thoroughly  
5. Submit a pull request  

---

## Credits

- **skycloud** — original `exolvl` format and Rust library  
- **NexusZen** — exoua project and Lua-first design  

---

## License

MIT License — see `LICENSE` for details
