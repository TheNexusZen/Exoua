local Level = {}
Level.__index = Level

local Read = require("exoua.read")
local Write = require("exoua.write")

local Brush = require("exoua.types.brush")
local Color = require("exoua.types.color")
local Layer = require("exoua.types.layer")
local Object = require("exoua.types.object")
local Pattern = require("exoua.types.pattern")
local Prefab = require("exoua.types.prefab")
local Theme = require("exoua.types.theme")
local Vec2 = require("exoua.types.vec2")
local NovaScript = require("exoua.types.novascript")
local Variable = require("exoua.types.novascript.variable")

function Level.new(data)
    return setmetatable(data, Level)
end

function Level.default(level_id)
    return Level.new({
        level_id = level_id,
        level_version = 1,
        nova_level = true,
        under_decoration_tiles = {},
        background_decoration_tiles = {},
        terrain_tiles = {},
        floating_zone_tiles = {},
        object_tiles = {},
        foreground_decoration_tiles = {},
        objects = {},
        layers = {},
        prefabs = {},
        brushes = {},
        patterns = {},
        color_palette = {},
        author_time = 0,
        author_lap_times = {},
        silver_medal_time = 0,
        gold_medal_time = 0,
        laps = 1,
        center_camera = false,
        scripts = {},
        nova_scripts = {},
        global_variables = {},
        theme = Theme.default(),
        custom_background_color = Color.new(),
        unknown1 = Read.zero_bytes(4),
        custom_terrain_pattern_id = 0,
        custom_terrain_pattern_tiling = Vec2.new(0, 0),
        custom_terrain_pattern_offset = Vec2.new(0, 0),
        custom_terrain_color = Color.new(),
        custom_terrain_secondary_color = Color.new(),
        custom_terrain_blend_mode = 0,
        custom_terrain_border_color = Color.new(),
        custom_terrain_border_thickness = 0.0,
        custom_terrain_border_corner_radius = 0.0,
        custom_terrain_round_reflex_angles = false,
        custom_terrain_round_collider = false,
        custom_terrain_friction = 0.0,
        default_music = true,
        music_ids = {},
        allow_direction_change = true,
        disable_replays = false,
        disable_revive_pads = false,
        disable_start_animation = false,
        gravity = Vec2.new(0.0, -75.0),
    })
end

function Level.read_versioned(reader, version)
    local self = {
        level_id = Read.uuid(reader),
        level_version = Read.i32(reader),
        nova_level = Read.bool(reader),
        under_decoration_tiles = Read.array(reader, Read.i32),
        background_decoration_tiles = Read.array(reader, Read.i32),
        terrain_tiles = Read.array(reader, Read.i32),
        floating_zone_tiles = Read.array(reader, Read.i32),
        object_tiles = Read.array(reader, Read.i32),
        foreground_decoration_tiles = Read.array(reader, Read.i32),
        objects = Read.array(reader, Object.read),
        layers = Read.array(reader, Layer.read),
        prefabs = Read.array(reader, Prefab.read),
        brushes = Read.array(reader, Brush.read),
        patterns = Read.array(reader, Pattern.read),
        color_palette = version >= 17 and Read.array(reader, Color.read) or nil,
        author_time = Read.i64(reader),
        author_lap_times = Read.array(reader, Read.i64),
        silver_medal_time = Read.i64(reader),
        gold_medal_time = Read.i64(reader),
        laps = Read.i32(reader),
        center_camera = Read.bool(reader),
        scripts = Read.array(reader, Read.i32),
        nova_scripts = Read.array(reader, NovaScript.read),
        global_variables = Read.array(reader, Variable.read),
        theme = Theme.read(reader),
        custom_background_color = Color.read(reader),
        unknown1 = Read.bytes(reader, 4),
        custom_terrain_pattern_id = Read.i32(reader),
        custom_terrain_pattern_tiling = Vec2.read(reader),
        custom_terrain_pattern_offset = Vec2.read(reader),
        custom_terrain_color = Color.read(reader),
        custom_terrain_secondary_color = Color.read(reader),
        custom_terrain_blend_mode = Read.i32(reader),
        custom_terrain_border_color = Color.read(reader),
        custom_terrain_border_thickness = Read.f32(reader),
        custom_terrain_border_corner_radius = Read.f32(reader),
        custom_terrain_round_reflex_angles = Read.bool(reader),
        custom_terrain_round_collider = Read.bool(reader),
        custom_terrain_friction = Read.f32(reader),
        default_music = Read.bool(reader),
        music_ids = Read.array(reader, Read.string),
        allow_direction_change = Read.bool(reader),
        disable_replays = Read.bool(reader),
        disable_revive_pads = Read.bool(reader),
        disable_start_animation = Read.bool(reader),
        gravity = Vec2.read(reader),
    }

    return Level.new(self)
end

function Level:write(writer)
    Writer.uuid(f, self.uuid)
    Write.i32(writer, self.level_version)
    Write.bool(writer, self.nova_level)
    Write.array(writer, self.under_decoration_tiles, Write.i32)
    Write.array(writer, self.background_decoration_tiles, Write.i32)
    Write.array(writer, self.terrain_tiles, Write.i32)
    Write.array(writer, self.floating_zone_tiles, Write.i32)
    Write.array(writer, self.object_tiles, Write.i32)
    Write.array(writer, self.foreground_decoration_tiles, Write.i32)
    Write.array(writer, self.objects, function(w, v) v:write(w) end)
    Write.array(writer, self.layers, function(w, v) v:write(w) end)
    Write.array(writer, self.prefabs, function(w, v) v:write(w) end)
    Write.array(writer, self.brushes, function(w, v) v:write(w) end)
    Write.array(writer, self.patterns, function(w, v) v:write(w) end)
    if self.color_palette then
        Write.array(writer, self.color_palette, function(w, v) v:write(w) end)
    end
    Write.i64(writer, self.author_time)
    Write.array(writer, self.author_lap_times, Write.i64)
    Write.i64(writer, self.silver_medal_time)
    Write.i64(writer, self.gold_medal_time)
    Write.i32(writer, self.laps)
    Write.bool(writer, self.center_camera)
    Write.array(writer, self.scripts, Write.i32)
    Write.array(writer, self.nova_scripts, function(w, v) v:write(w) end)
    Write.array(writer, self.global_variables, function(w, v) v:write(w) end)
    self.theme:write(writer)
    self.custom_background_color:write(writer)
    Write.bytes(writer, self.unknown1)
    Write.i32(writer, self.custom_terrain_pattern_id)
    self.custom_terrain_pattern_tiling:write(writer)
    self.custom_terrain_pattern_offset:write(writer)
    self.custom_terrain_color:write(writer)
    self.custom_terrain_secondary_color:write(writer)
    Write.i32(writer, self.custom_terrain_blend_mode)
    self.custom_terrain_border_color:write(writer)
    Write.f32(writer, self.custom_terrain_border_thickness)
    Write.f32(writer, self.custom_terrain_border_corner_radius)
    Write.bool(writer, self.custom_terrain_round_reflex_angles)
    Write.bool(writer, self.custom_terrain_round_collider)
    Write.f32(writer, self.custom_terrain_friction)
    Write.bool(writer, self.default_music)
    Write.array(writer, self.music_ids, Write.string)
    Write.bool(writer, self.allow_direction_change)
    Write.bool(writer, self.disable_replays)
    Write.bool(writer, self.disable_revive_pads)
    Write.bool(writer, self.disable_start_animation)
    self.gravity:write(writer)
end

return Level
