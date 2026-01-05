-- generate.lua

math.randomseed(os.time())

package.path =
    "./src/?.lua;" ..
    "./src/?/init.lua;" ..
    package.path

local Level = require("exoua.types.level")

-- UUID v4 as TABLE of 16 bytes (THIS is what writer.uuid wants)
local function uuid_v4()
    local u = {}

    for i = 1, 16 do
        u[i] = math.random(0, 255)
    end

    -- version 4
    u[7] = (u[7] & 0x0F) | 0x40
    -- variant 10xx
    u[9] = (u[9] & 0x3F) | 0x80

    return u
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

print("Generated test.exolvl successfully")
