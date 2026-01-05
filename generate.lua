local Writer   = require("src.exoua.writer")
local Sections = require("src.exoua.sections")
local Types    = require("src.exoua.types")

local output = assert(io.open("out.exolvl", "wb"))

local level = {
    metadata = {
        title = "Generated Level",
        description = "",
        author = "Exoua",
        version = 1,
    },

    theme = {
        id = 0,
    },

    layers = {},

    objects = {},

    patterns = {},

    prefabs = {},

    scripts = {},

    author_replay = nil,
}

Writer.write(output, {
    Sections.Metadata(level.metadata),
    Sections.Theme(level.theme),
    Sections.Layers(level.layers),
    Sections.Objects(level.objects),
    Sections.Patterns(level.patterns),
    Sections.Prefabs(level.prefabs),
    Sections.Scripts(level.scripts),
    Sections.AuthorReplay(level.author_replay),
})

output:close()
