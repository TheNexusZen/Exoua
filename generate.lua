package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

local write_exolvl = require("exoua.writer")

local sections = {
    {
        id = "metadata",
        data = require("exoua.types.metadata")({
            version = 1,
        }),
    },
    {
        id = "theme",
        data = require("exoua.types.theme")({}),
    },
    {
        id = "layers",
        data = {},
    },
    {
        id = "objects",
        data = {},
    },
    {
        id = "patterns",
        data = {},
    },
    {
        id = "prefabs",
        data = {},
    },
    {
        id = "scripts",
        data = {},
    },
}

local out = assert(io.open("out.exolvl", "wb"))
write_exolvl(out, sections)
out:close()
