package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

local Types = require("exoua.types")

math.randomseed(os.time() + tonumber(tostring({}):sub(8), 16))

local function uuid_v4()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return template:gsub("[xy]", function(c)
        local v = (c == "x") and math.random(0, 15)
                  or math.random(8, 11)
        return string.format("%x", v)
    end)
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
