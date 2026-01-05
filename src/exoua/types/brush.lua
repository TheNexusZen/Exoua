local Read = require("exoua.read")
local Write = require("exoua.write")
local Vec2 = require("exoua.types.vec2")
local ObjectProperty = require("exoua.types.object_property")

local Brush = {}
Brush.__index = Brush

function Brush.new(brush_id, spread, frequency, grid, objects)
    return setmetatable({
        brush_id = brush_id,
        spread = spread,
        frequency = frequency,
        grid = grid,
        objects = objects,
    }, Brush)
end

function Brush.read(reader)
    return Brush.new(
        Read.i32(reader),
        Vec2.read(reader),
        Read.f32(reader),
        BrushGrid.read(reader),
        Read.vec(reader, BrushObject.read)
    )
end

function Brush.write(writer, self)
    Write.i32(writer, self.brush_id)
    Vec2.write(writer, self.spread)
    Write.f32(writer, self.frequency)
    BrushGrid.write(writer, self.grid)
    Write.vec(writer, self.objects, BrushObject.write)
end

local BrushObject = {}
BrushObject.__index = BrushObject

function BrushObject.new(entity_id, properties, weight, scale, rotation, flip_x, flip_y)
    return setmetatable({
        entity_id = entity_id,
        properties = properties,
        weight = weight,
        scale = scale,
        rotation = rotation,
        flip_x = flip_x,
        flip_y = flip_y,
    }, BrushObject)
end

function BrushObject.read(reader)
    return BrushObject.new(
        Read.i32(reader),
        Read.vec(reader, ObjectProperty.read),
        Read.f32(reader),
        Read.f32(reader),
        Read.f32(reader),
        Read.bool(reader),
        Read.bool(reader)
    )
end

function BrushObject.write(writer, self)
    Write.i32(writer, self.entity_id)
    Write.vec(writer, self.properties, ObjectProperty.write)
    Write.f32(writer, self.weight)
    Write.f32(writer, self.scale)
    Write.f32(writer, self.rotation)
    Write.bool(writer, self.flip_x)
    Write.bool(writer, self.flip_y)
end

local BrushGrid = {}
BrushGrid.__index = BrushGrid

function BrushGrid.new(x, y)
    return setmetatable({
        x = x,
        y = y,
    }, BrushGrid)
end

function BrushGrid.read(reader)
    return BrushGrid.new(
        Read.i32(reader),
        Read.i32(reader)
    )
end

function BrushGrid.write(writer, self)
    Write.i32(writer, self.x)
    Write.i32(writer, self.y)
end

return {
    Brush = Brush,
    BrushObject = BrushObject,
    BrushGrid = BrushGrid,
}
