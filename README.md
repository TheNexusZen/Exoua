# exoua

Lua-first Exoracer level generator.

exoua lets you describe Exoracer levels using Lua, then converts them into .exolvl files with a very small Rust backend.

Lua controls everything.  
Rust only writes the final level file.

---

## How it works

1. You write a level in Lua  
2. Lua outputs a simple data structure  
3. Rust reads that data  
4. Rust writes a valid `.exolvl` file  

---

## TODO

- [ ] Define full Lua level API  
- [ ] Support basic objects (platforms, spikes, etc.)  
- [x] Deterministic IDs and ordering  
- [x] Optional CLI arguments  
- [ ] AI-generated Lua support  
- [ ] Documentation for all Lua functions  
- [ ] Implement ExoScript / NovaScript support  

---

## Credits

- **skycloud** — original `exolvl` format and Rust library  
- **NexusZen** — exoua project and Lua-based design  

---

## License

MIT
