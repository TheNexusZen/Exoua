-- seed RNG (SAFE)
math.randomseed(os.time())

-- UUID v4 generator
local function uuid_v4()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return template:gsub("[xy]", function(c)
        local v
        if c == "x" then
            v = math.random(0, 15)
        else
            v = math.random(8, 11)
        end
        return string.format("%x", v)
    end)
end

-- requires
local level_type = require("exoua.types.level")

-- build level
local level = {
    uuid = uuid_v4(),
    name = "Generated Level",
    description = "",
    authorTime = 0,

    layers = {
        {
            uuid = uuid_v4(),
            name = "Main Layer",
            objects = {
                {
                    uuid = uuid_v4(),
                    name = "Test Object",

                    position = { x = 0, y = 0 },
                    rotation = 0,
                    scale = { x = 1, y = 1 },

                    prefab = {
                        shape = "box",
                        width = 1,
                        height = 1,
                    }
                }
            }
        }
    }
}

-- write file
local f = assert(io.open("test.exolvl", "wb"))
level_type.write(f, level)
f:close()

print("Generated test.exolvl")
print("Level UUID:", level.uuid)
