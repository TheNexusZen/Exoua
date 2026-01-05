-- generate.lua

math.randomseed(os.time())

package.path =
    "./src/?.lua;" ..
    "./src/?/init.lua;" ..
    package.path

local Level = require("exoua.types.level")

-- UUID v4 as RAW 16-BYTE STRING
local function uuid_v4()
    local bytes = {}

    for i = 1, 16 do
        bytes[i] = math.random(0, 255)
    end

    -- Version 4
    bytes[7] = (bytes[7] & 0x0F) | 0x40
    -- Variant 10xx
    bytes[9] = (bytes[9] & 0x3F) | 0x80

    -- Convert to binary string (THIS IS THE KEY)
    return string.char(table.unpack(bytes))
end

local file = assert(io.open("test.exolvl", "wb"))

local level = {
    uuid = uuid_v4(),
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

print("Generated test.exolvl (correct UUID format)")
