local Exolvl = {}
Exolvl.__index = Exolvl

local Read = require("exoua.read")
local Write = require("exoua.write")
local LocalLevel = require("exoua.types.local_level")
local LevelData = require("exoua.types.level_data")
local AuthorReplay = require("exoua.types.author_replay")

local EXPECTED_MAGIC = "NYA^"

function Exolvl.new(local_level, level_data, author_replay)
    return setmetatable({
        local_level = local_level,
        level_data = level_data,
        author_replay = author_replay,
    }, Exolvl)
end

function Exolvl.read(reader)
    local magic = Read.bytes(reader, 4)
    if magic ~= EXPECTED_MAGIC then
        error("WrongMagic")
    end

    local local_level = LocalLevel.read(reader)
    local level_data = LevelData.read_versioned(reader, local_level.serialization_version)
    local author_replay = AuthorReplay.read(reader)

    return Exolvl.new(local_level, level_data, author_replay)
end

function Exolvl:write(writer)
    Write.bytes(writer, EXPECTED_MAGIC)
    self.local_level:write(writer)
    self.level_data:write(writer)
    self.author_replay:write(writer)
end

function Exolvl.default()
    local local_level = LocalLevel.default()
    local level_data = LevelData.default()
    local author_replay = AuthorReplay.new({})
    return Exolvl.new(local_level, level_data, author_replay)
end

return Exolvl
