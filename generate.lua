-- allow requiring from ./src
package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

-- RNG seed
math.randomseed(os.time())

local function uuid_bytes()
    local t = {}
    for i = 1, 16 do
        t[i] = string.char(math.random(0, 255))
    end

    -- RFC 4122 v4 bits
    t[7] = string.char((string.byte(t[7]) & 0x0F) | 0x40)
    t[9] = string.char((string.byte(t[9]) & 0x3F) | 0x80)

    return table.concat(t)
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
