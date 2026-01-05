-- generate.lua
-- Minimal .exolvl generator that DOES NOT rely on OO writer

-- make sure Lua can find ./src
package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

local writer = require("exoua.writer")

-- open output file
local f = assert(io.open("test.exolvl", "wb"))

----------------------------------------------------------------
-- EXOLVL HEADER
----------------------------------------------------------------

-- Magic: "EXOL"
writer.i32(f, 0x4C4F5845) -- little-endian "EXOL"

-- Version
writer.i32(f, 1)

----------------------------------------------------------------
-- LEVEL CORE DATA (minimal)
----------------------------------------------------------------

-- Level ID (int)
writer.i32(f, 1)

-- Seed
writer.i32(f, 0)

-- Difficulty
writer.i32(f, 0)

----------------------------------------------------------------
-- EMPTY SECTIONS (no metadata, no prefabs, no scripts)
----------------------------------------------------------------

-- Prefab count
writer.i32(f, 0)

-- Script count
writer.i32(f, 0)

-- Object count
writer.i32(f, 0)

----------------------------------------------------------------
-- END
----------------------------------------------------------------

f:close()

print("Generated test.exolvl successfully")
