-- generate.lua

math.randomseed(os.time())

package.path =
    "./src/?.lua;" ..
    "./src/?/init.lua;" ..
    package.path

local Level = require("exoua.types.level")

-- UUID v4 generator (correct format)
local function uuid_v4()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return template:gsub("[xy]", function(c)
        local v = (c == "x") and math.random(0, 15)
                   or math.random(8, 11)
        return string.format("%x", v)
    end)
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

print("Generated test.exolvl")
print("UUID:", level.uuid)
