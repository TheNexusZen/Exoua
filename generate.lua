-- generate.lua

-- make sure Lua can see ./src
package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

local Level = require("exoua.types.level")
local Writer = require("exoua.writer")

-- open output file
local file = assert(io.open("test.exolvl", "wb"))

-- construct a level object
local level = Level.new({
    version = 1,

    -- REQUIRED: must be a list, not nil
    layers = {
        {
            id = 1,
            name = "Main",

            -- REQUIRED: must contain at least one object
            objects = {
                {
                    id = 1,

                    position = { x = 0, y = 0 },
                    rotation = 0,
                    scale = { x = 1, y = 1 },

                    -- minimal prefab
                    prefab = {
                        name = "test_object",
                        properties = {}
                    }
                }
            }
        }
    },

    -- REQUIRED: empty list is
