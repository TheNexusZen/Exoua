local Read = require("exoua.read")
local Write = require("exoua.write")

local AuthorReplay = require("exoua.types.author_replay")
local LocalLevel = require("exoua.types.local_level")
local Object = require("exoua.types.object")
local Pattern = require("exoua.types.pattern")
local Theme = require("exoua.types.theme")

local LevelData = {}
LevelData.__index = LevelData

function LevelData.new(t)
    return setmetatable(t, LevelData)
end

function LevelData.read(r)
    return LevelData.new({
        author_replay = AuthorReplay.read(r),
        local_level = LocalLevel.read(r),
        objects = Read.list(r, Object),
        patterns = Read.list(r, Pattern),
        themes = Read.list(r, Theme),
    })
end

function LevelData:write(w)
    self.author_replay:write(w)
    self.local_level:write(w)
    Write.list(w, self.objects)
    Write.list(w, self.patterns)
    Write.list(w, self.themes)
end

return LevelData
