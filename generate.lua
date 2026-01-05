package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

math.randomseed(os.time())

local Types = require("exoua.types")

local function uuid16()
    local t = {}
    for i = 1, 16 do
        t[i] = math.random(0, 255)
    end
    return string.char(table.unpack(t))
end

local level = {
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
            objects = {},
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
