local Object = {}
Object.__index = Object

local Vec2 = require("exoua.types.vec2")
local ObjectProperty = require("exoua.types.object_property")
local Read = require("exoua.read")
local Write = require("exoua.write")

function Object.new(args)
    return setmetatable({
        entity_id = args.entity_id or 0,
        tile_id = args.tile_id or 0,
        prefab_entity_id = args.prefab_entity_id or 0,
        prefab_id = args.prefab_id or 0,
        position = args.position or Vec2.new(0, 0),
        scale = args.scale or Vec2.new(1, 1),
        rotation = args.rotation or 0.0,
        tag = args.tag or "",
        properties = args.properties or {},
        in_layer = args.in_layer or 0,
        in_group = args.in_group or 0,
        group_members = args.group_members or {},
    }, Object)
end

function Object.read(reader)
    return Object.new({
        entity_id = Read.i32(reader),
        tile_id = Read.i32(reader),
        prefab_entity_id = Read.i32(reader),
        prefab_id = Read.i32(reader),
        position = Vec2.read(reader),
        scale = Vec2.read(reader),
        rotation = Read.f32(reader),
        tag = Read.string(reader),
        properties = Read.vec(reader, ObjectProperty.read),
        in_layer = Read.i32(reader),
        in_group = Read.i32(reader),
        group_members = Read.vec(reader, Read.i32),
    })
end

function Object:write(writer)
    Write.i32(writer, self.entity_id)
    Write.i32(writer, self.tile_id)
    Write.i32(writer, self.prefab_entity_id)
    Write.i32(writer, self.prefab_id)
    self.position:write(writer)
    self.scale:write(writer)
    Write.f32(writer, self.rotation)
    Write.string(writer, self.tag)
    Write.vec(writer, self.properties, function(w, prop)
        prop:write(w)
    end)
    Write.i32(writer, self.in_layer)
    Write.i32(writer, self.in_group)
    Write.vec(writer, self.group_members, Write.i32)
end

return Object
