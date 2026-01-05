package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

math.randomseed(os.time())

local Types = require("exoua.types")

-- Generate 16 RAW BYTES (this is what writer.uuid requires)
local function uuid16()
    local bytes = {}
    for i = 1, 16 do
        bytes[i] = string.char(math.random(0, 255))
    end
    return table.concat(bytes)
end

local level = {
    -- MUST be 16 raw bytes
    uuid = uuid16(),

    name = "Generated Level",
    description = "",

    metadata = {
        created_time = os.time(),
        modified_time = os.time(),
    },

    layers = {
        {
            layer_id = 0,
            name = "Main",
            visible = true,
            locked = false,

            objects = {
                {
                    object_id = 0,
                    prefab_id = 0,
                    position = { x = 0, y = 0 },
                    rotation = 0,
                    scale = { x = 1, y = 1 },
                    color = { r = 255, g = 255, b = 255, a = 255 },
                }
            }
        }
    },

    novascript = {
        variables = {},
        actions = {},
    }
}

local f = assert(io.open("test.exolvl", "wb"))
Types.level.write(f, level)
f:close()

print("test.exolvl generated successfully")
