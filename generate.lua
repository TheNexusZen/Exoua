-- allow requiring from ./src
package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

-- RNG seed
math.randomseed(os.time())

-- UUID v4 (string, writer converts to bytes)
local function uuid_v4()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return template:gsub("[xy]", function(c)
        local v = (c == "x") and math.random(0, 15) or math.random(8, 11)
        return string.format("%x", v)
    end)
end

-- require level writer
local Level = require("exoua.types.level")

-- build level table
local level = {
    uuid = uuid_v4(),
    name = "Generated Level",
    description = "",
    authorTime = 0,

    layers = {
        {
            uuid = uuid_v4(),
            name = "Layer 1",

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
Level.write(f, level)
f:close()

print("Generated test.exolvl")
print("UUID:", level.uuid)
