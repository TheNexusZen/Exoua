local Layer = {}
Layer.__index = Layer

local Read = require("exoua.read")
local Write = require("exoua.write")
local Vec2 = require("exoua.types.vec2")

function Layer.new(layer_id, layer_name, selected, invisible, locked, foreground_type, parallax, fixed_size, children)
    return setmetatable({
        layer_id = layer_id or 0,
        layer_name = layer_name or "",
        selected = selected or false,
        invisible = invisible or false,
        locked = locked or false,
        foreground_type = foreground_type or 0,
        parallax = parallax or Vec2.new(0, 0),
        fixed_size = fixed_size or false,
        children = children or {},
    }, Layer)
end

function Layer.read(reader)
    return Layer.new(
        Read.i32(reader),
        Read.string(reader),
        Read.bool(reader),
        Read.bool(reader),
        Read.bool(reader),
        Read.i32(reader),
        Vec2.read(reader),
        Read.bool(reader),
        Read.array(reader, Read.i32)
    )
end

function Layer:write(writer)
    Write.i32(writer, self.layer_id)
    Write.string(writer, self.layer_name)
    Write.bool(writer, self.selected)
    Write.bool(writer, self.invisible)
    Write.bool(writer, self.locked)
    Write.i32(writer, self.foreground_type)
    self.parallax:write(writer)
    Write.bool(writer, self.fixed_size)
    Write.array(writer, self.children, Write.i32)
end

return Layer
