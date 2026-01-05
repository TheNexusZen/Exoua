-- generate.lua

-- allow Lua to find ./src
package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

local Level = require("exoua.types.level")

-- open output file
local file = assert(io.open("test.exolvl", "wb"))

-- create level
local level = Level.new({
    version = 1,

    layers = {
        {
            id = 1,
            name = "Main",

            objects = {
                {
                    id = 1,

                    position = { x = 0, y = 0 },
                    rotation = 0,
                    scale = { x = 1, y = 1 },

                    prefab = {
                        name = "test_object",
                        properties = {}
                    }
                }
            }
        }
    },

    prefabs = {},
    scripts = {},
})

-- write level
level:write(file)
file:close()

print("Generated test.exolvl")
