-- generate.lua

-- Seed RNG (important for UUID randomness)
math.randomseed(os.time() + tonumber(tostring({}):sub(8), 16))

-- Fix package path for GitHub Actions / local
package.path =
    "./src/?.lua;" ..
    "./src/?/init.lua;" ..
    package.path

local Level  = require("exoua.types.level")
local Writer = require("exoua.writer")
local uuid   = require("exoua.types.uuid")

-- Create writer
local file = assert(io.open("test.exolvl", "wb"))

-- Create level data
local level = {
    uuid = uuid.random(),   -- MUST be random
    version = 1,

    name = "Generated Level",

    author_time = 0,

    -- MUST exist even if empty
    objects = {},
    layers = {},
    prefabs = {},
    patterns = {},
    themes = {},
    scripts = {},
}

-- Write level
Level.write(file, level)

file:close()

print("Generated test.exolvl successfully")
