-- generate.lua

math.randomseed(os.time())

package.path =
    "./src/?.lua;" ..
    "./src/?/init.lua;" ..
    package.path

local Level = require("exoua.types.level")

-- UUID v4 -> 16 raw bytes
local function uuid_v4_bytes()
    local bytes = {}

    for i = 1, 16 do
        bytes[i] = math.random(0, 255)
    end

    -- version 4
    bytes[7] = (bytes[7] & 0x0F) | 0x40
    -- variant 10xx
    bytes[9] = (bytes[9] & 0x3F) | 0x80

    return bytes
end

local file = assert(io.open("test.exolvl", "wb"))

local level = {
    uuid = uuid_v4_bytes(),
    version = 1,

    name = "Generated Level",

    author_time = 0,

    objects  = {},
    layers   = {},
    prefabs  = {},
    patterns = {},
    themes   = {},
    scripts  = {},
}

Level.write(file, level)
file:close()

print("Generated test.exolvl (binary UUID)")
