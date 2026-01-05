-- generate.lua
package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

local writer = require("exoua.writer")

local f = assert(io.open("test.exolvl", "wb"))

--------------------------------------------------
-- HEADER
--------------------------------------------------
writer.i32(f, 0x4C4F5845) -- "EXOL"
writer.i32(f, 1)          -- version

--------------------------------------------------
-- LEVEL CORE
--------------------------------------------------
writer.i32(f, 1) -- level id
writer.i32(f, 0) -- seed
writer.i32(f, 0) -- difficulty

--------------------------------------------------
-- LAYERS
--------------------------------------------------
writer.i32(f, 1)          -- layer count

-- layer 0
writer.i32(f, 0)          -- layer id
writer.string(f, "Main")  -- layer name
writer.bool(f, true)      -- visible
writer.bool(f, true)      -- locked

--------------------------------------------------
-- OBJECTS
--------------------------------------------------
writer.i32(f, 1) -- object count

-- object 0
writer.i32(f, 0)   -- object id
writer.i32(f, 0)   -- layer id

-- position (vec2)
writer.i32(f, 0)   -- x
writer.i32(f, 0)   -- y

-- rotation / scale (defaults)
writer.i32(f, 0)   -- rotation
writer.i32(f, 1)   -- scale

--------------------------------------------------
-- SCRIPTS
--------------------------------------------------
writer.i32(f, 0)

--------------------------------------------------
-- PREFABS
--------------------------------------------------
writer.i32(f, 0)

f:close()

print("Generated minimal loadable test.exolvl")
