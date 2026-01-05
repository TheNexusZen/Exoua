local Vec2 = {}
Vec2.__index = Vec2

local Read = require("exoua.read")
local Write = require("exoua.write")

function Vec2.new(x, y)
    return setmetatable({
        x = x or 0.0,
        y = y or 0.0,
    }, Vec2)
end

function Vec2.read(reader)
    return Vec2.new(
        Read.f32(reader),
        Read.f32(reader)
    )
end

function Vec2:write(writer)
    Write.f32(writer, self.x)
    Write.f32(writer, self.y)
end

return Vec2
