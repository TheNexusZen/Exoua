package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

math.randomseed(os.time())

local Types = require("exoua.types")

local function uuid16()
    local t = {}
    for i = 1, 16 do
        t[i] = string.char(math.random(0, 255))
    end
    return table.concat(t)
end

local level = {
    uuid = uuid16(),
    name = "Generated Level",
    metadata = {
        created_time = os.time(),
        modified_time = os.time(),
    },
    layers = {
