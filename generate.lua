package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

local write_exolvl = require("exoua.writer")

local out = assert(io.open("out.exolvl", "wb"))

write_exolvl(out, {
    { id = "metadata", data = {} },
    { id = "theme", data = {} },
    { id = "layers", data = {} },
    { id = "objects", data = {} },
    { id = "patterns", data = {} },
    { id = "prefabs", data = {} },
    { id = "scripts", data = {} },
})

out:close()
