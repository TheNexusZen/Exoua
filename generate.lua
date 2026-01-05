package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

local Writer   = require("exoua.writer")
local Sections = require("exoua.sections")

local out = assert(io.open("out.exolvl", "wb"))

Writer.write(out, {
    Sections.Metadata({}),
    Sections.Theme({}),
    Sections.Layers({}),
    Sections.Objects({}),
    Sections.Patterns({}),
    Sections.Prefabs({}),
    Sections.Scripts({}),
})

out:close()
