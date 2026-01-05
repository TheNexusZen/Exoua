math.randomseed(os.time())

local Writer = require("exoua.writer")
local Types  = require("exoua.types")

local function uuid16()
    local t = {}
    for i = 1, 16 do
        t[i] = math.random(0, 255)
    end
    return t
end

local level = {
    uuid = uuid16(),
    name = "Generated Level",
    description = "",
    metadata = {
        version = 1,
        created_time = os.time(),
        modified_time = os.time(),
    },
    layers = {
        {
            layer_id = 0,
            name = "Layer 1",
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
            },
        }
    },
    novascript = {
        variables = {},
        actions = {},
    }
}

local file = assert(io.open("test.exolvl", "wb"))
Types.level.write(file, level)
file:close()

print("test.exolvl generated")
