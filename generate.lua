package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

local Writer = require("exoua.writer")
local Metadata = require("exoua.types.metadata")
local Level = require("exoua.types.level")

local writer = Writer:new("test.exolvl")

local metadata = Metadata.new({
    level = Level.new({
        data = {
            author_replay = {
                author = "",
                replay = "",
            },
            local_level = {
                id = "00000000-0000-0000-0000-000000000000",
                created_at = 0,
                updated_at = 0,
            },
            objects = {},
            patterns = {},
            themes = {},
        },
    }),
})

metadata:write(writer)
writer:close()
