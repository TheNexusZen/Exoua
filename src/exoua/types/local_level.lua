local Read = require("exoua.read")
local Write = require("exoua.write")
local Uuid = require("exoua.types.uuid")
local DateTime = require("exoua.types.datetime")

local LocalLevel = {}
LocalLevel.__index = LocalLevel

function LocalLevel.new(
    serialization_version,
    level_id,
    level_version,
    level_name,
    thumbnail,
    creation_date,
    update_date,
    author_time,
    author_lap_times,
    silver_medal_time,
    gold_medal_time,
    laps,
    private,
    nova_level
)
    return setmetatable({
        serialization_version = serialization_version,
        level_id = level_id,
        level_version = level_version,
        level_name = level_name,
        thumbnail = thumbnail,
        creation_date = creation_date,
        update_date = update_date,
        author_time = author_time,
        author_lap_times = author_lap_times,
        silver_medal_time = silver_medal_time,
        gold_medal_time = gold_medal_time,
        laps = laps,
        private = private,
        nova_level = nova_level,
    }, LocalLevel)
end

function LocalLevel.read(reader)
    return LocalLevel.new(
        Read.i32(reader),
        Uuid.read(reader),
        Read.i32(reader),
        Read.string(reader),
        Read.string(reader),
        DateTime.read(reader),
        DateTime.read(reader),
        Read.i64(reader),
        Read.vec(reader, Read.i64),
        Read.i64(reader),
        Read.i64(reader),
        Read.i32(reader),
        Read.bool(reader),
        Read.bool(reader)
    )
end

function LocalLevel.write(writer, self)
    Write.i32(writer, self.serialization_version)
    Uuid.write(writer, self.level_id)
    Write.i32(writer, self.level_version)
    Write.string(writer, self.level_name)
    Write.string(writer, self.thumbnail)
    DateTime.write(writer, self.creation_date)
    DateTime.write(writer, self.update_date)
    Write.i64(writer, self.author_time)
    Write.vec(writer, self.author_lap_times, Write.i64)
    Write.i64(writer, self.silver_medal_time)
    Write.i64(writer, self.gold_medal_time)
    Write.i32(writer, self.laps)
    Write.bool(writer, self.private)
    Write.bool(writer, self.nova_level)
end

function LocalLevel.default_with_id(level_id)
    return LocalLevel.new(
        18,
        level_id,
        1,
        "New level",
        "",
        DateTime.now(),
        DateTime.now(),
        0,
        {},
        0,
        0,
        1,
        false,
        true
    )
end

return LocalLevel
