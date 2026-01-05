package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

local binary = require("exoua.binary")
local writer = require("exoua.writer")
local sections = require("exoua.sections")

local types = require("exoua.types")
local Level = types.level
local LocalLevel = types.local_level
local Layer = types.layer

-- output file
local f = assert(io.open("test.exolvl", "wb"))

-- =========================
-- LocalLevel (REQUIRED)
-- =========================
local local_level = {
    uuid = "00000000-0000-0000-0000-000000000001",
    created_at = os.time(),
    updated_at = os.time(),
}

sections.write(f, sections.LOCAL_LEVEL, function()
    LocalLevel.write(f, local_level)
end)

-- =========================
-- LevelData (REQUIRED)
-- =========================
local level = {
    width = 1024,
    height = 1024,
    origin = { x = 0, y = 0 },
    active_layer = 0,
    layers = {
        {
            id = 0,
            name = "Layer 1",
            visible = true,
            locked = false,
        }
    },
    objects = {},
    scripts = {},
}

sections.write(f, sections.LEVEL, function()
    Level.write(f, level)
end)

f:close()

print("Generated test.exolvl")
